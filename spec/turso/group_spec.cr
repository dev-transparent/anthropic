require "../spec_helper"

describe Turso::Group do
  describe ".create" do
    it "creates a new group" do
      WebMock.stub(:post, "https://api.turso.tech/v1/organizations/org/groups")
        .with(
          body: "{\"location\":\"iad\",\"name\":\"default\"}",
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json"
          }
        )
        .to_return(
          body: <<-BODY
            {
              "group": {
                "name": "default",
                "version": "v0.23.7",
                "uuid": "0a28102d-6906-11ee-8553-eaa7715aeaf2",
                "locations": [
                  "iad"
                ],
                "primary": "iad",
                "archived": false
              }
            }
          BODY
        )

      Turso.configure do |settings|
        settings.organization = "org"
        settings.token = "token"
      end

      group = Turso::Group.create(location: "iad", name: "default")
      group.should be_a(Turso::Group)

      group.name.should eq("default")
      group.primary.should eq("iad")
      group.uuid.should_not be_empty
    end

    it "handles errors" do
      WebMock.stub(:post, "https://api.turso.tech/v1/organizations/org/groups")
        .with(
          body: "{\"location\":\"iad\",\"name\":\"default\"}",
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json"
          }
        )
        .to_return(
          body: <<-BODY
            {
              "error": "Failed to create group"
            }
          BODY
        )

      Turso.configure do |settings|
        settings.organization = "org"
        settings.token = "token"
      end

      expect_raises Turso::Error, "Failed to create group" do
        Turso::Group.create(location: "iad", name: "default")
      end
    end
  end
end