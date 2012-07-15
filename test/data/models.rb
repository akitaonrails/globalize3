# this little innocent class here makes 0.0.9 test fail
class Translation < ActiveRecord::Base
end

class Article < ActiveRecord::Base
  attr_accessible :body, :body_html, :title, :locale, :translations_attributes

  translates :title, :body, :body_html
  accepts_nested_attributes_for :translations

  before_save :generate_html

  class Translation
    attr_accessible :locale, :title, :body, :body_html
  end

  def translations_attributes=(attributes)
    new_translations = attributes.values.reduce({}) do |new_values, translation|
      translation.merge!("body_html" => RDiscount.new(translation["body"] || "").to_html )
      new_values.merge! translation.delete("locale") => translation
    end
    set_translations new_translations
  end

private
  def generate_html
    self.body_html = RDiscount.new(self.body || "").to_html
  end
end


class Post < ActiveRecord::Base
  translates :title, :content, :published, :published_at, :versioning => true
  validates_presence_of :title
  scope :with_some_title, :conditions => { :title => 'some_title' }
end

class PostTranslation < ActiveRecord::Base
  def existing_method ; end
end

class ReloadingPost < Post
  after_create { reload }
end

class Blog < ActiveRecord::Base
  has_many :posts, :order => 'id ASC'
end


class Validatee < ActiveRecord::Base
  translates :string
end

module Nested
  class NestedValidatee < ActiveRecord::Base
    translates :string
  end
end


class Parent < ActiveRecord::Base
  translates :content
end

class Child < Parent
end

class Comment < ActiveRecord::Base
  validates_presence_of :content
  belongs_to :post
end

class TranslatedComment < Comment
  translates :content
end

class User < ActiveRecord::Base
  translates :name
  validates_presence_of :name, :email
end

class Migrated < ActiveRecord::Base
  translates :name
end

class MigratedWithMegaUltraSuperLongModelNameWithMoreThenSixtyCharacters < ActiveRecord::Base
  translates :name
end

class UppercaseTableName < ActiveRecord::Base
  self.table_name = "UPPERCASE_TABLE_NAME"
  translates :name
end

class Untranslated < ActiveRecord::Base
end

class Task < ActiveRecord::Base
  translates :name, :fallbacks_for_empty_translations => true
  cattr_accessor :fallbacks
  def globalize_fallbacks(locale)
    self.class.fallbacks || super
  end
end

class NewsItem < ActiveRecord::Base
  translates :name, :foreign_key => :news_id
  self.table_name = :news
end

class Page < ActiveRecord::Base
  translates :title
  translates :body
end
