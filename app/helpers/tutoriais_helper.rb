module TutoriaisHelper
  def url_para(item)
    "#{url_for}/#{item}"
  end

  def url_imagem(imagem)
    "/imagens/#{imagem}"
  end

  def url_tutorial(tutorial)
    "#{tutoriais_path}/#{tutorial}"
  end
end