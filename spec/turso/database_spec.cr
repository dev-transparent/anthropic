require "../spec_helper"

describe Turso::Database do
  describe ".create" do
    it "creates a new database" do
      WebMock.stub(:post, "https://api.turso.tech/v1/organizations/org/databases")
        .with(
          body: "{\"group\":\"default\",\"name\":\"test\"}",
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json"
          }
        )
        .to_return(
          body: <<-BODY
            {
              "database": {
                "DbId": "0eb771dd-6906-11ee-8553-eaa7715aeaf2",
                "Hostname": "test-org.turso.io",
                "Name": "test"
              }
            }
          BODY
        )

      Turso.configure do |settings|
        settings.organization = "org"
        settings.token = "token"
      end

      database = Turso::Database.create(group: "default", name: "test")
      database.should be_a(Turso::Database)

      database.name.should eq("test")
      database.uuid.should_not be_empty
      database.hostname.should_not be_empty
    end

    it "handles errors" do
      WebMock.stub(:post, "https://api.turso.tech/v1/organizations/org/databases")
        .with(
          body: "{\"group\":\"default\",\"name\":\"test\"}",
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json"
          }
        )
        .to_return(
          body: <<-BODY
            {
              "error": "Failed to create database"
            }
          BODY
        )

      Turso.configure do |settings|
        settings.organization = "org"
        settings.token = "token"
      end

      expect_raises Turso::Error, "Failed to create database" do
        Turso::Database.create(group: "default", name: "test")
      end
    end
  end
end