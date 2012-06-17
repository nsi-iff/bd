def verificar_breadcrumbs(url, content)
  visit url
  within('#breadcrumbs') { page.should have_content content }
end
