FOO_TEAM = {
  name: "Foos",
  rank: 1,
  users: [
    {
      name: "Mario Lopez",
      email: "lil@mr.e",
      tos_acceptance: true,
      address: {
        street: "foosgonewild"
      },
      profile: {
        introduction: "foosgonewild.com/shop",
        hobbies: ["stuntin'"]
      },
      meta: {
        created_at: DateTime.parse("2019-09-01"),
        updated_at: DateTime.parse("2019-09-01"),
        uuid: "f0000000-f000-f000-f000-f00000000000"
      }
    }
  ],
  budget: {
    amount: 1_000_000,
    meta: {
      created_at: DateTime.parse("2019-09-01"),
      updated_at: DateTime.parse("2019-09-01"),
      uuid: "f0000000-f000-f000-f000-f00000000000"
    }
  },
  meta: {
    created_at: DateTime.parse("2019-09-01"),
    updated_at: DateTime.parse("2019-09-01"),
    uuid: "f0000000-f000-f000-f000-f00000000000"
  }
}.freeze

class FooClass
  attr_accessor :name, :rank, :users, :budget, :meta
end

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

      context "for templated YAML files (erb)" do
        context "without class declarations" do
          let(:file) { get_file("fixture_team_hash.yml.erb") }

          it "fails" do
            # TODO: Add lib-specific error class here
            expect { read }.to raise_error(StandardError)
          end
        end
      end
    end
  end

  describe "extended module" do
    context "for templated YAML files (erb)" do
      context "without class delcarations" do
        xit "instantiates a hash" do
          # TODO
        end

        xit "injects necessary template variables" do
          # TODO
        end
      end

      context "with class delcarations" do
        xit "instantiates the declared class" do
          # TODO
        end

        xit "injects necessary template variables" do
          # TODO
        end
      end
    end
  end
end
