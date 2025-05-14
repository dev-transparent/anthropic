require "spec"
require "webmock"
require "../src/turso"

Spec.before_each do
  WebMock.reset
end