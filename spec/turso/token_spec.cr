require "../spec_helper"

describe Turso::Token do
  describe ".create" do
    it "creates a new token" do
      WebMock.stub(:post, "https://api.turso.tech/v1/organizations/org/databases/db/auth/tokens")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json"
          }
        )
        .to_return(
          body: <<-BODY
            {
              "jwt": "fake jwt"
            }
          BODY
        )

      Turso.configure do |settings|
        settings.organization = "org"
        settings.token = "token"
      end

      token = Turso::Token.create(database: "db")
      token.should be_a(Turso::Token)

      token.jwt.should eq("fake jwt")
    end

    it "handles errors" do
      WebMock.stub(:post, "https://api.turso.tech/v1/organizations/org/databases/db/auth/tokens")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json"
          }
        )
        .to_return(
          body: <<-BODY
            {
              "error": "Failed to create token"
            }
          BODY
        )

      Turso.configure do |settings|
        settings.organization = "org"
        settings.token = "token"
      end

      expect_raises Turso::Error, "Failed to create token" do
        Turso::Token.create(database: "db")
      end
    end
  end
end