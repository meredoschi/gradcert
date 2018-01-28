# Some useful extensions
module ActiveRecordExtension
  extend ActiveSupport::Concern

  # Starting day in numeric format.  Number of days since application's "epoch"
  def startday
    (start - Settings.dayone).to_i
  end

  # Completion day in numeric format.  Number of days since application's "epoch"
  def finishday
    (finish - Settings.dayone).to_i
  end

  # Alias
  def numdays
    dayrange
  end

  # Interval
  def interval
    (daystarted..dayfinished)
  end

  # Number of days
  def dayrange
    finishday - startday + 1
  end

  # id enclosed in curly braces
  # Useful for debugging and rake tasks
  def curly
    print ' { ' + id.to_s + ' }'
  end

  def created_when
    I18n.t('created_at') + I18n.l(created_at).downcase
  end

  def updated_when
    I18n.t('updated_at') + I18n.l(updated_at).downcase
  end

  # http://stackoverflow.com/questions/2328984/rails-extending-activerecordbase
  # add your static(class) methods here
  module ClassMethods
    # Returns maximum id
    # Used in fixes_nov_17 (new_programs)
    def max_id
      pluck(:id).max
    end

    # Alias, useful for seeding
    def offset
      max_id
    end

    # Returns next available id
    # Used in fixes_nov_17 (new_programs)
    def next_id
      max_id + 1
    end

    # E.g: Order.top_ten
    def top_ten
      limit(10)
    end

    # E.g: Order.top_hundred - useful for testing and debug activities
    def top_hundred
      limit(100)
    end

    # Generic methods - work for arbitrary dates
    def created_on(dt)
      where('created_at > ? and created_at < ?', dt, dt + 1.day)
    end

    def not_created_on(dt)
      where('created_at <= ? or created_at > ?', dt, dt + 1.day)
    end

    def updated_on(dt)
      where('updated_at > ? and updated_at < ?', dt, dt + 1.day)
    end

    def not_updated_on(dt)
      where('updated_at <= ? or updated_at > ?', dt, dt + 1.day)
    end

    def created_after(dt)
      where('created_at > ?', dt)
    end

    def created_before(dt)
      where('created_at < ?', dt)
    end

    # Today - Convenience methods
    def created_today
      dt = Date.today
      created_on(dt)
    end

    def not_created_today
      dt = Date.today
      not_created_on(dt)
    end

    def not_updated_today
      dt = Date.today
      not_updated_on(dt)
    end

    def updated_today
      dt = Date.today
      updated_on(dt)
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)
