# encoding: utf-8

require 'spec_helper'

describe PagesHelper do
  describe "link_to_manual" do
    it "produz um link para o manual especifico" do
      helper.link_to_manual("manual", "manual.pdf").should ==
      '<a href="/arquivos/manuais/manual.pdf" target="_blank">manual</a>'
    end
  end

  describe "link_to_tutorial" do
    it "produz um link para o tutorial especifico" do
      helper.link_to_tutorial("tutorial", "tutorial.pdf").should ==
      '<a href="/arquivos/tutoriais/tutorial.pdf" target="_blank">tutorial</a>'
    end
  end
end