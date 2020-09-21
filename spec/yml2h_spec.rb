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
          expect(read).to be_an(Array)
          expect(read.length).to eq(2)
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
