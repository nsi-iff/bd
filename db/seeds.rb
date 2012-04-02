# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

def carregar_idiomas
  File.read(File.join("#{Rails.root}", 'db', 'seeds', 'idiomas.txt')).each_line do |idioma|
    sigla, descricao = idioma.split(";").map(&:strip)
    Idioma.create! sigla: sigla, descricao: descricao
  end
end

carregar_idiomas if Idioma.count == 0

##############  Seeds para opções "grau" em trabalho de obtencação de grau ############

# Criando as opções
Grau.criar_todos if Grau.count == 0

############################### Seeds para Papeis ################################

Papel.criar_todos if Papel.count == 0

#################### Seeds para Eixos temáticos e cursos #######################

# Criando eixo Ambiente e Saúde e seus cursos
def criar_cursos_e_eixos_tematicos
  ambiente_saude = EixoTematico.create(nome: 'Ambiente e Saúde')
  ambiente_saude.cursos.create([
    { nome: 'Gestão Ambiental'    },
    { nome: 'Gestão Hospitalar'   },
    { nome: 'Oftálmica'           },
    { nome: 'Radiologia'          },
    { nome: 'Saneamento Ambiental'},
    { nome: 'Sistemas Biomédicos' }
  ])

  # Criando eixo Apoio Escolar e seu curso
  apoio_escolar = EixoTematico.create(nome: 'Apoio Escolar')
  apoio_escolar.cursos.create([
    { nome: 'Processos Escolares'}
  ])

  # Criando eixo Controle e Processos Industriais e seus cursos
  controle_processos_industriais = EixoTematico.create(nome: 'Controle e Processos Industriais')
  controle_processos_industriais.cursos.create([
    { nome: 'Automação Industrial'         },
    { nome: 'Eletrônica Industrial'        },
    { nome: 'Eletrotécnica Industrial'     },
    { nome: 'Gestão da Produção Industrial'},
    { nome: 'Manutenção de Aeronaves'      },
    { nome: 'Manutenção Industrial'        },
    { nome: 'Mecânica de Precisão'         },
    { nome: 'Mecatrônica Industrial'       },
    { nome: 'Processos Ambientais'         },
    { nome: 'Processos Metalúrgicos'       },
    { nome: 'Processos Químicos'           },
    { nome: 'Sistemas Elétricos'           }
  ])

  # Criando eixo Gestão e Negócios e seus cursos
  gestao_negocios = EixoTematico.create(nome: 'Gestão e Negócios')
  gestao_negocios.cursos.create([
    { nome: 'Comércio Exterior'         },
    { nome: 'Gestão Comercial'          },
    { nome: 'Gestão da Qualidade'       },
    { nome: 'Gestão de Cooperativas'    },
    { nome: 'Gestão de Recursos Humanos'},
    { nome: 'Gestão Financeira'         },
    { nome: 'Gestão Pública'            },
    { nome: 'Logística'                 },
    { nome: 'Marketing'                 },
    { nome: 'Negócios Imobiliários'     },
    { nome: 'Processos Gerenciais'      },
    { nome: 'Secretariado'              }
  ])

  # Criando eixo Hospitalidade e Lazer e seus cursos
  hospitalidade_lazer = EixoTematico.create(nome: 'Hospitalidade e Lazer')
  hospitalidade_lazer.cursos.create([
    { nome: 'Eventos'                     },
    { nome: 'Gastronomia'                 },
    { nome: 'Gestão Desportiva e de Lazer'},
    { nome: 'Gestão de Turismo'           },
    { nome: 'Hotelaria'                   }
  ])

  # Criando eixo Informação e Comunicação e seus cursos
  informacao_comunicacao = EixoTematico.create(nome: 'Informação e Comunicação')
  informacao_comunicacao.cursos.create([
    { nome: 'Análise e Desenvolvimento de Sistemas'},
    { nome: 'Banco de Dados'                       },
    { nome: 'Geoprocessamento'                     },
    { nome: 'Gestão da Tecnologia da Informação'   },
    { nome: 'Gestão de Telecomunicações'           },
    { nome: 'Jogos Digitais'                       },
    { nome: 'Redes de Computadores'                },
    { nome: 'Redes de Telecomunicações'            },
    { nome: 'Segurança da Informação'              },
    { nome: 'Sistemas de Telecomunicações'         },
    { nome: 'Sistemas para Internet'               },
    { nome: 'Telemática'                           }
  ])

  # Criando eixo Infraestrutura e seus cursos
  infraestrutura = EixoTematico.create(nome: 'Infraestrutura')
  infraestrutura.cursos.create([
    { nome: 'Agrimensura'                        },
    { nome: 'Construção de Edifícios'            },
    { nome: 'Controle de Obras'                  },
    { nome: 'Estradas'                           },
    { nome: 'Gestão Portuária'                   },
    { nome: 'Material de Construção'             },
    { nome: 'Obras Hidráulicas'                  },
    { nome: 'Pilotagem Profissional de Aeronaves'},
    { nome: 'Sistemas de Navegação Fluvial'      },
    { nome: 'Transporte Aéreo'                   },
    { nome: 'Transporte Terrestre'               }
  ])

  # Criando eixo Militar e seus cursos
  militar = EixoTematico.create(nome: 'Militar')
  militar.cursos.create([
    { nome: 'Comunicações Aeronáuticas'      },
    { nome: 'Fotointeligência'               },
    { nome: 'Gerenciamento de Tráfego Aéreo' },
    { nome: 'Gestão e Manutenção Aeronáutica'},
    { nome: 'Meteorologia Aeronáutica'       },
    { nome: 'Sistemas de Armas'              }
  ])

  # Criando eixo Produção Alimentícia e seus cursos
  producao_alimenticia = EixoTematico.create(nome: 'Produção Alimentícia')
  producao_alimenticia.cursos.create([
    { nome: 'Agroindústria'          },
    { nome: 'Alimentos'              },
    { nome: 'Laticínios'             },
    { nome: 'Processamento de Carnes'},
    { nome: 'Produção de Cachaça'    },
    { nome: 'Viticultura e Enologia' }
  ])

  # Criando eixo Produção Cultural e Design e seus cursos
  producao_cultural_design = EixoTematico.create(nome: 'Produção Cultural e Design')
  producao_cultural_design.cursos.create([
    { nome: 'Comunicação Assistiva'    },
    { nome: 'Comunicação Institucional'},
    { nome: 'Conservação e Restauro'   },
    { nome: 'Design de Interiores'     },
    { nome: 'Design de Moda'           },
    { nome: 'Design de Produto'        },
    { nome: 'Design Gráfico'           },
    { nome: 'Fotografia'               },
    { nome: 'Produção Audiovisual'     },
    { nome: 'Produção Cênica'          },
    { nome: 'Produção Cultural'        },
    { nome: 'Produção Fonográfica'     },
    { nome: 'Produção Multimídia'      },
    { nome: 'Produção Publicitária'    }
  ])

  # Criando eixo Produção Industrial e seus cursos
  producao_industrial = EixoTematico.create(nome: 'Produção Industrial')
  producao_industrial.cursos.create([
    { nome: 'Biocombustíveis'         },
    { nome: 'Construção Naval'        },
    { nome: 'Fabricação Mecânica'     },
    { nome: 'Papel e Celulose'        },
    { nome: 'Petróleo e Gás'          },
    { nome: 'Polímeros'               },
    { nome: 'Produção de Vestuário'   },
    { nome: 'Produção Gráfica'        },
    { nome: 'Produção Joalheira'      },
    { nome: 'Produção Moveleira'      },
    { nome: 'Produção Sucroalcooleira'},
    { nome: 'Produção Têxtil'         }
  ])

  # Criando eixo Recursos Naturais e seus cursos
  recursos_naturais = EixoTematico.create(nome: 'Recursos Naturais')
  recursos_naturais.cursos.create([
    { nome: 'Agroecologia'        },
    { nome: 'Agronegócio'         },
    { nome: 'Aquicultura'         },
    { nome: 'Cafeicultura'        },
    { nome: 'Horticultura'        },
    { nome: 'Irrigação e Drenagem'},
    { nome: 'Produção de Grãos'   },
    { nome: 'Produção Pesqueira'  },
    { nome: 'Rochas Ornamentais'  },
    { nome: 'Silvicultura'        }
  ])

  # Criando eixo Segurança e seus cursos
  seguranca = EixoTematico.create(nome: 'Segurança')
  seguranca.cursos.create([
    { nome: 'Gestão de Segurança Privada'},
    { nome: 'Segurança no Trabalho'      },
    { nome: 'Segurança no Trânsito'      },
    { nome: 'Segurança Pública'          },
    { nome: 'Serviços Penais'            }
  ])
end

criar_cursos_e_eixos_tematicos if EixoTematico.count == 0

#######################  Seeds para Áreas e sub-áreas #######################

def criar_areas_e_sub_areas
  Area.delete_all
  SubArea.delete_all
  #Criando Ciências Exatas e da Terra
  exatas = Area.create(nome: 'Ciências Exatas e da Terra')
  #Criando sub_areas para exatas
  exatas.sub_areas.create([
          { nome: 'Astronomia'                    },
          { nome: 'Ciência da Computação'         },
          { nome: 'Física'                        },
          { nome: 'Geociências'                   },
          { nome: 'Matemática'                    },
          { nome: 'Oceanografia'                  },
          { nome: 'Probabilidade e Estatística'   },
          { nome: 'Química'                       }
  ])

  #Criando areas biologicas
  biologicas = Area.create(nome: 'Ciências Biológicas')
  #Criando sub_areas para biologicas
  biologicas.sub_areas.create([
          { nome: 'Biofísica'        },
          { nome: 'Biologia Geral'   },
          { nome: 'Bioquimíca'       },
          { nome: 'Botânica'         },
          { nome: 'Ecologia'         },
          { nome: 'Farmacologia'     },
          { nome: 'Fisiologia'       },
          { nome: 'Genética'         },
          { nome: 'Imunologia'       },
          { nome: 'Microbiologia'    },
          { nome: 'Morfologia'       },
          { nome: 'Parasitologia'    },
          { nome: 'Zoologia'         }
  ])

  #Criando areas Engenharias
  engenharias = Area.create(nome: 'Engenharias')
  #Criando sub_ares para Engenharias
  engenharias.sub_areas.create([
          { nome: 'Engenharia Aeroespacial'                 },
          { nome: 'Engenharia Biomédica'                    },
          { nome: 'Engenharia Civil'                        },
          { nome: 'Engenharia de Materiais e Metalúrgica'   },
          { nome: 'Engenharia de Minas'                     },
          { nome: 'Engenharia de Produção'                  },
          { nome: 'Engenharia de Transportes'               },
          { nome: 'Engenharia Elétrica'                     },
          { nome: 'Engenharia Mecânica'                     },
          { nome: 'Engenharia Naval e Oceânica'             },
          { nome: 'Engenharia Nuclear'                      },
          { nome: 'Engenharia Química'                      },
          { nome: 'Engenharia Sanitária'                    }
  ])

  #Criando areas saúde
  saude = Area.create(nome: 'Ciências da Saúde')
  #Criando sub_areas para saúde
  saude.sub_areas.create([
          { nome: 'Educação Física'                      },
          { nome: 'Enfermagem'                           },
          { nome: 'Farmácia'                             },
          { nome: 'Fisioterapia e Terapia Ocupacional'   },
          { nome: 'Fonoaudiologia'                       },
          { nome: 'Medicina'                             },
          { nome: 'Nutrição'                             },
          { nome: 'Odontologia'                          },
          { nome: 'Saude Coletiva'                       }
  ])

  #Criando areas Ciências Agrárias
  agrarias = Area.create(nome: 'Ciências Agrárias')
  #Criando sub_areas para Ciências Agrárias
  agrarias.sub_areas.create([
          { nome: 'Agronomia'                                    },
          { nome: 'Ciência e Tecnologia de Alimentos'            },
          { nome: 'Engenharia Agrícola'                          },
          { nome: 'Medicina Veterinária'                         },
          { nome: 'Recursos Florestais e Engenharia Florestal'   },
          { nome: 'Recursos Pesqueiros e Engenharia de Pesca'    },
          { nome: 'Zootecnia'                                    }
  ])

  #Criando areas Ciências Sociais Aplicadas
  sociais_aplicadas = Area.create(nome: 'Ciências Sociais Aplicadas')
  #Criando sub_areas para Ciências Sociais Aplicadas
  sociais_aplicadas.sub_areas.create([
          { nome: 'Administração'                    },
          { nome: 'Arquitetura e Urbanismo'          },
          { nome: 'Ciência da Informação'            },
          { nome: 'Comunicação'                      },
          { nome: 'Demografia'                       },
          { nome: 'Desenho Industrial'               },
          { nome: 'Direito'                          },
          { nome: 'Economia'                         },
          { nome: 'Economia Doméstica'               },
          { nome: 'Museologia'                       },
          { nome: 'Planejamento Urbano e Regional'   },
          { nome: 'Serviço Social'                   },
          { nome: 'Turismo'                          }
  ])

  #Criando areas Ciências Humanas
  humanas = Area.create(nome: 'Ciências Humanas')
  #Criando sub_areas para Ciências Humanas
  humanas.sub_areas.create([
          { nome: 'Antropologia'       },
          { nome: 'Arqueologia'        },
          { nome: 'Ciência Política'   },
          { nome: 'Educação'           },
          { nome: 'Filosofia'          },
          { nome: 'Geografia'          },
          { nome: 'História'           },
          { nome: 'Psicologia'         },
          { nome: 'Sociologia'         },
          { nome: 'Teologia'           }
  ])

  #Criando areas Linguística, Letras e Artes
  linguisticas_letras_e_artes = Area.create(nome: 'Linguística, Letras e Artes')
  #Criando sub_areas para Linguística, Letras e Artes
  linguisticas_letras_e_artes.sub_areas.create([
          { nome: 'Artes'        },
          { nome: 'Letras'       },
          { nome: 'Liguística'   }
  ])

  #Criando areas Outras
  outras = Area.create(nome: 'Outras')
  #Criando sub_areas para Outras
  outras.sub_areas.create([
          { nome: 'Administração Hospitalar'    },
          { nome: 'Administracao Rural'         },
          { nome: 'Biomedicina'                 },
          { nome: 'Carreira Militar'            },
          { nome: 'Carreira Religiosa'          },
          { nome: 'Ciências'                    },
          { nome: 'Ciências Atuarias'           },
          { nome: 'Ciências Sociais'            },
          { nome: 'Decoração'                   },
          { nome: 'Desenho de Moda'             },
          { nome: 'Desenho de Projetos'         },
          { nome: 'Diplomacia'                  },
          { nome: 'Engenharia Cartográfica'     },
          { nome: 'Engenharia de Agrimensura'   },
          { nome: 'Engenharia de Armamentos'    },
          { nome: 'Engenharia Mecatrônica'      },
          { nome: 'Engenharia Têxtil'           },
          { nome: 'Estudos Sociais'             },
          { nome: 'História Natural'            },
          { nome: 'Multidisciplinar'            },
          { nome: 'Química Industrial'          },
          { nome: 'Relações Internacionais'     },
          { nome: 'Relações Públicas'           },
          { nome: 'Secretariado Executivo'      },
          { nome: 'Outra'                       }
  ])
end

criar_areas_e_sub_areas if Area.count == 0

def popular_instituicao_campus
  Instituicao.destroy_all
  Campus.destroy_all

  iffluminense = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense')
  iffluminense.campus.create([
    { nome: 'Campus Bom Jesus de Itabapoana' },
    { nome: 'Campus Cabo Frio'               },
    { nome: 'Campus Campos Centro'           },
    { nome: 'Campus Campos Guarus'           },
    { nome: 'Campus Itaperuna'               },
    { nome: 'Campus Macaé'                   }
  ])

  ifamapa = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Amapá')
  ifamapa.campus.create([
    { nome: 'Campus Macapá' }
  ])
end
popular_instituicao_campus
