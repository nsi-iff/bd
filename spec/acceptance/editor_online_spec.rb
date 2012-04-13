# encoding: UTF-8

require 'spec_helper'

feature "editor online" do
  scenario "fazer download do conteúdo do editor" do
    visit "/editor"
    fill_in "documento", with: "teste"
    click_button "Download"
    headers['Content-Transfer-Encoding'].should == 'binary'
    headers['Content-Type'].should == 'text/html'
    page.body.should match("teste")
  end

  def headers
    page.response_headers
  end
end
