# encoding: utf-8

def breadcrumb_separator
  '»'
end

def verificar_breadcrumbs(url, content)
  block_given? ? yield(url) : visit(url)
  within('#breadcrumbs') do
    page.should have_content content
    page.should_not have_link(
      content.split(breadcrumb_separator).last.strip)
  end
end
