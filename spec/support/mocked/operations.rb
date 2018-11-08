# frozen_string_literal: true

MockedResult = Struct.new(:result) do
  def success?
    result
  end
end

MockedOperation = Struct.new(:result) do
  def call
    result
  end
end
