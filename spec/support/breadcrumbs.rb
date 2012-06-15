def pagina_deve_ter_breadcrumbs(content)
  within('#breadcrumbs') { page.should have_content content }
end
