RSpec.describe Yml2h do
  it "has a version number" do
    expect(Yml2h::VERSION).not_to be nil
  end
end

RSpec.describe Yml2h::Read do
  describe "module function" do
    let(:read) { described_class.read_from_yaml(file) }

    context "for normal YAML files" do
      context "without class declarations" do
        let(:file) { get_file("team_hash.yml") }

        it "instantiates a hash" do
          expect(read).to be_a(Hash)
        end
      end

      context "with class declarations" do
        let(:file) { get_file("team_ostruct.yml") }

        it "instantiates the declared class" do
          expect(read).to be_an(OpenStruct)
        end
      end
    end

    context "for templated YAML files (erb)" do
      let(:file) { get_file("fixture_team_hash.yml.erb") }

      it "fails" do
        # TODO: Add lib-specific error class here
        expect { read }.to raise_error(StandardError)
      end
    end
  end

  describe "extended module" do
    context "for templated YAML files (erb)" do
      let(:read) { extended_klass.read_from_yaml!(file) }
      subject { stub_foo }

      context "without class delcarations" do
        let(:file) { get_file("fixture_team_hash.yml.erb") }

        it "instantiates a hash" do
          expect(read).to be_a(Hash)
        end

        it "injects necessary template variables" do
          FOO_TEAM.each do |key, val|
            expect(read[key]).to eq(val)
          end
        end
      end

      context "with class delcarations" do
        let(:file) { get_file("fixture_team_ostruct.yml.erb") }

        it "instantiates the declared class" do
          expect(read).to be_an(OpenStruct)
        end

        it "injects necessary template variables" do
          FOO_TEAM.each do |key, val|
            expect(read.public_send(key)).to eq(val)
          end
        end
      end
    end
  end
end

RSpec.describe Yml2h::Compile do
  describe "module function" do
    let(:read) { described_class.compile_from_dir(dir) }

    context "for normal YAML files" do
      context "without class declarations" do
        let(:dir) { get_file("compile_yml/") }

        it "returns an array" do
          ary = read

          expect(ary).to be_an(Array)
          expect(ary.length).to eq(2)
        end
      end
    end
  end

  describe "extended module" do
    let(:read) { extended_klass.extend(Yml2h::Read).compile_from_dir!(dir) }

    context "for templated YAML files (erb)" do
      let(:dir) { get_file("compile_erb/") }
      subject { stub_foo }

      it "injects necessary template variables" do
        hash = read.to_h

        expect(hash.dig("meta", :meta)).to eq(FOO_TEAM[:meta])
        expect(hash.dig("users", :users)).to eq(FOO_TEAM[:users])
      end
    end
  end
end

RSpec.describe Yml2h::Write do
  let(:file) { Tempfile.new(File.expand_path("../tmp", __dir__)) }
  after(:each) do
    file.close
    file.unlink
  end

  describe "module function" do
    let(:write) { described_class.write_to_yaml(input, file) }

    context "for ruby hashes" do
      let(:input) { {foo: "FOO", bar: 1, baz: Time.now} }

      it "does not fail" do
        expect { write }.to_not raise_error
      end
    end

    context "for other ruby classes" do
      let(:input) { OpenStruct.new({foo: "FOO", bar: 1, baz: Time.now}) }

      it "does not fail" do
        expect { write }.to_not raise_error
      end
    end
  end

  describe "extended module" do
    let(:write) { extended_klass.write_to_yaml!(file) }

    context "for ruby hashes" do
      subject { {foo: "FOO", bar: 1, baz: Time.now} }

      it "does not fail" do
        expect { write }.to_not raise_error
      end
    end

    context "for other ruby classes" do
      subject { OpenStruct.new({foo: "FOO", bar: 1, baz: Time.now}) }

      it "does not fail" do
        expect { write }.to_not raise_error
      end
    end
  end
end
