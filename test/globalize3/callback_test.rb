# encoding: utf-8

require File.expand_path('../../test_helper', __FILE__)
require 'rdiscount'

class CallbackTest < Test::Unit::TestCase
  def setup
    @params = {"translations_attributes"=>{
      "0"=>{"title"=>"Hello World", "body"=>"**Markdown Test**", "locale"=>"en"},
      "1"=>{"title"=>"Olá Mundo", "body"=>"__Teste de Markdown__", "locale"=>"pt-BR"}}}
  end

  test "should create both translations through nested attributes assignment" do
    @article = Article.new(@params)
    assert_equal 2, @article.translations.size

    assert @article.save
    @article.reload

    assert_equal 2, @article.translations.size

    I18n.locale = :en
    assert_equal "<p><strong>Markdown Test</strong></p>\n", @article.body_html

    I18n.locale = :"pt-BR"
    assert_equal "<p><strong>Teste de Markdown</strong></p>\n", @article.body_html
  end
end

