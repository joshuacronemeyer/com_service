# frozen_string_literal: true

class Email
  attr_accessor :to, :to_name, :from, :from_name, :subject, :body
  def initialize(to:, to_name:, from:, from_name:, subject:, body:)
    @to = to
    @to_name = to_name
    @from = from
    @from_name = from_name
    @subject = subject
    @body = body
  end

  def valid?
    %i[to to_name from_name from subject body].all? { |attr| has_required_attr?(attr) }
  end

  def plain_text_body
    body.gsub(/<[^>]*>/, '')
  end

  private

  def has_required_attr?(attr)
    attr_val = send(attr)
    !attr_val.nil? && attr_val != ''
  end
end
