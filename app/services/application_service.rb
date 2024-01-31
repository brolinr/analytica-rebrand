# frozen_string_literal: true

class ApplicationService
  attr_reader :params, :context

  def initialize(params: {}, context: {}, **_args)
    @params = params
    @context = context
  end

  def self.call(params: {}, context: {}, **args)
    new(params: params, context: context).call(**args)
  end

  def step(method)
    send(method)
  end

  def preload(*methods)
    methods.map { |method| send(method) }
  end

  def call
    raise NotImplementedError, '#call method must be implemented'
  end

  def transaction
    ActiveRecord::Base.transaction do
      result = yield
      raise ActiveRecord::Rollback unless result
    end
  rescue ActiveRecord::Rollback => e
    e.message
  end
end
