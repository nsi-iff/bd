def verificar_breadcrumbs(url, content)
  block_given? ? yield(url) : visit(url)
  within('#breadcrumbs') { page.should have_content content }
end
