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

def criar_instituicoes_e_campus_associados
  Instituicao.delete_all
  Campus.delete_all

  outra = Insituicao.create(nome: 'Outro')
  outra.campus.create(nome: '----')

  iftocantins = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Tocantins')
  iftocantins.campus.create([
    { nome: 'Campus Araguatins'           },
    { nome: 'Campus Gurupi'               },
    { nome: 'Campus Palmas'               },
    { nome: 'Campus Paraíso do Tocantins' },
    { nome: 'Campus Porto Nacional'       },
  ])

  ifmato_grosso = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Mato Grosso')
  ifmato_grosso.campus.create([
    { nome: 'Campus Barra do Garças'       },
    { nome: 'Campus Bela Vista/Cuiabá'     },
    { nome: 'Campus Cáceres'               },
    { nome: 'Campus Campo Novo do Parecis' },
    { nome: 'Campus Confresa'              },
    { nome: 'Campus Cuiabá'                },
    { nome: 'Campus Juína'                 },
    { nome: 'Campus Pontes e Lacerda'      },
    { nome: 'Campus Rondonópolis'          },
    { nome: 'Campus São Vicente'           },
  ])

  ifpara = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Pará')
  ifpara.campus.create([
    { nome: 'Campus Agrícola de Marabá'    },
    { nome: 'Campus Altamira'              },
    { nome: 'Campus Avançado de Breves'    },
    { nome: 'Campus Belém'                 },
    { nome: 'Campus Bragança'              },
    { nome: 'Campus Castanhal'             },
    { nome: 'Campus Conceição do Araguaia' },
    { nome: 'Campus Itaituba'              },
    { nome: 'Campus Marabá'                },
    { nome: 'Campus Santarém'              },
    { nome: 'Campus Tucuruí'               },
  ])

  ifparaiba = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia da Paraíba')
  ifparaiba.campus.create([
    { nome: 'Campus Cajazeiras'      },
    { nome: 'Campus Campina Grande'  },
    { nome: 'Campus João Pessoa'     },
    { nome: 'Campus Monteiro'        },
    { nome: 'Campus Patos'           },
    { nome: 'Campus Picuí'           },
    { nome: 'Campus Princesa Isabel' },
    { nome: 'Campus Sousa'           },
  ])

  ifsergipe = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Sergipe')
  ifsergipe.campus.create([
    { nome: 'Campus Estância'                },
    { nome: 'Campus Itabaiana'               },
    { nome: 'Campus Lagarto'                 },
    { nome: 'Campus Nossa Senhora da Glória' },
    { nome: 'Campus São Cristóvão'           },
  ])

  ifceara = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Ceará')
  ifceara.campus.create([
    { nome: 'Campus Avançado de Aracati'            },
    { nome: 'Campus Avançado de Baturité'           },
    { nome: 'Campus Avançado de Camocim'            },
    { nome: 'Campus Aavnçado de Caucaia'            },
    { nome: 'Campus Avançado de Jaguaribe'          },
    { nome: 'Campus Avançado de Morada Nova'        },
    { nome: 'Campus Avançado de Tabuleiro do Norte' },
    { nome: 'Campus Avançado de Tauá'               },
    { nome: 'Campus Avançado de Tianguá'            },
    { nome: 'Campus Avançado de Ubajara'            },
    { nome: 'Campus Canindé'                        },
    { nome: 'Campus Cedro'                          },
    { nome: 'Campus Crateús'                        },
    { nome: 'Campus Crato'                          },
    { nome: 'Campus Fortaleza'                      },
    { nome: 'Campus Iguatu'                         },
    { nome: 'Campus Juazeiro do Norte'              },
    { nome: 'Campus Limoeiro do Norte'              },
    { nome: 'Campus Maracanaú'                      },
    { nome: 'Campus Quixadá'                        },
    { nome: 'Campus Sobral'                         },
  ])

  ifroraima = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Roraima')
  ifroraima.campus.create([
    { nome: 'Campus Boa Vista'},
    { nome: 'Campus Novo Paraíso'},
  ])

  ifalagoas = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Alagoas')
  ifalagoas.campus.create([
    { nome: 'Campus Avançado de Murici'                },
    { nome: 'Campus Avançado de Santana do Ipanema'    },
    { nome: 'Campus Avançado de São Miguel dos Campos' },
    { nome: 'Campus Maceió'                            },
    { nome: 'Campus Maragogi'                          },
    { nome: 'Campus Marechal Deodoro'                  },
    { nome: 'Campus Palmeira dos Indios'               },
    { nome: 'Campus Penedo'                            },
    { nome: 'Campus Piranhas (Xingó)'                  },
    { nome: 'Campus Satuba'                            },
  ])

  ifcatarinense = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Catarinense')
  ifcatarinense.campus.create([
    { nome: 'Campus Avançado de Blumenau'            },
    { nome: 'Campus Avançado de Fraiburgo'           },
    { nome: 'Campus Avançado de Ibirama'             },
    { nome: 'Campus Avançado de Luzern'              },
    { nome: 'Campus Avançado de São Francisco do Sul'},
    { nome: 'Campus Camboriú'                        },
    { nome: 'Campus Concórdia'                       },
    { nome: 'Campus Rio do Sul'                      },
    { nome: 'Campus Sombrio'                         },
    { nome: 'Campus Videira'                         },
  ])

  ifsuldeminas = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Sul de Minas')
  ifsuldeminas.campus.create([
    { nome: 'Campus Avançado de Poços de Caldas' },
    { nome: 'Campus Avançado de Pouso Alegre'    },
    { nome: 'Campus Inconfidentes'               },
    { nome: 'Campus Machado'                     },
    { nome: 'Campus Muzambinho'                  },
  ])

  ifsaopaulo = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de São Paulo')
  ifsaopaulo.campus.create([
    { nome: 'Campus Avançado de Boituva'   },
    { nome: 'Campus Avançado de Capivari'  },
    { nome: 'Campus Avançado de Jacareí'   },
    { nome: 'Campus Avançado de Matão'     },
    { nome: 'Campus Avaré'                 },
    { nome: 'Campus Barretos'              },
    { nome: 'Campus Birigui'               },
    { nome: 'Campus Bragança Paulista'     },
    { nome: 'Campus Campinas'              },
    { nome: 'Campus Campos do Jordão'      },
    { nome: 'Campus Caraguatatuba'         },
    { nome: 'Campus Catanduva'             },
    { nome: 'Campus Cubatão'               },
    { nome: 'Campus Guarulhos'             },
    { nome: 'Campus Hortolandia'           },
    { nome: 'Campus Itapetininga'          },
    { nome: 'Campus Piracicaba'            },
    { nome: 'Campus Presidente Epitácio'   },
    { nome: 'Campus Registro'              },
    { nome: 'Campus Salto'                 },
    { nome: 'Campus São Carlos'            },
    { nome: 'Campus São João da Boa Vista' },
    { nome: 'Campus São José dos Campos'   },
    { nome: 'Campus São Paulo'             },
    { nome: 'Campus São Roque'             },
    { nome: 'Campus Sertãozinho'           },
    { nome: 'Campus Suzano'                },
    { nome: 'Campus Votuporanga'           },
  ])

  iftriangulomineiro = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Triângulo Mineiro')
  iftriangulomineiro.campus.create([
    { nome: 'Campus Avançado de Uberlândia'},
    { nome: 'Campus Ituiutaba'},
    { nome: 'Campus Paracatu'},
    { nome: 'Campus Uberaba'},
    { nome: 'Campus Uberlândia'},
  ])

  ifminasgerais = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Minas Gerais')
  ifminasgerais.campus.create([
    { nome: 'Campus Avançado de Ouro Branco'        },
    { nome: 'Campus Avançado de Ribeirão das Neves' },
    { nome: 'Campus Bambuí'                         },
    { nome: 'Campus Congonhas'                      },
    { nome: 'Campus Formiga'                        },
    { nome: 'Campus Governador Valadares'           },
    { nome: 'Campus Ouro Preto'                     },
    { nome: 'Campus São João Evangelista'           },
  ])

  utfpr = Instituicao.create(nome: 'Universidade Tecnológica Federal do Paraná')
  utfpr.campus.create([
    { nome: 'Campus Campo Mourão'      },
    { nome: 'Campus Cornelio Procopio' },
    { nome: 'Campus Curitiba UTFPR'    },
    { nome: 'Campus Dois Vizinhos'     },
    { nome: 'Campus Francisco Beltrão' },
    { nome: 'Campus Londrina'          },
    { nome: 'Campus Medianeira'        },
    { nome: 'Campus Pato Branco'       },
    { nome: 'Campus Ponta Grossa'      },
    { nome: 'Campus Toledo'            },
  ])

  ifsertaopernambucano = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Sertão Pernambucano')
  ifsertaopernambucano.campus.create([
    { nome: 'Campus Ouricuri' },
    { nome: 'Campus Salgueiro' },
    { nome: 'Petrolina' },
    { nome: 'Petrolina Zona Rural' },
  ])

  ifms = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Mato Grosso do Sul')
  ifms.campus.create([
    { nome: 'Campus de Aquidauana'  },
    { nome: 'Campus de Corumbá'     },
    { nome: 'Campus de Coxim'       },
    { nome: 'Campus de Ponta Porã'  },
    { nome: 'Campus de Três Lagoas' },
    { nome: 'Campus Nova Andradina' },
  ])

  ifbaiano = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Baiano')
  ifbaiano.campus.create([
    { nome: 'Campus Catu'                },
    { nome: 'Campus Guanambi'            },
    { nome: 'Campus Itapetinga'          },
    { nome: 'Campus Santa Inês'          },
    { nome: 'Campus Senhor do Bonfim'    },
    { nome: 'Campus Teixeira de Freitas' },
    { nome: 'Campus Uruçuca'             },
    { nome: 'Campus Valença'             },
  ])

  ifro = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Rondonia')
  ifro.campus.create([
    { nome: 'Campus Avançado de Cacoal'      },
    { nome: 'Campus Avançado de Porto Velho' },
    { nome: 'Campus Colorado do Oeste'       },
    { nome: 'Campus Ji'                      },
    { nome: 'Campus Porto Velho'             },
    { nome: 'Campus Vilhena'                 },
  ])

  ifrs = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Rio Grande do Sul')
  ifrs.campus.create([
    { nome: 'Campus Avançado de Feliz'       },
    { nome: 'Campus Avançado de Ibirubá'     },
    { nome: 'Campus Avançado de Rolante'     },
    { nome: 'Campus Bento Gonçalves'         },
    { nome: 'Campus Canoas'                  },
    { nome: 'Campus Caxias do Sul'           },
    { nome: 'Campus Erechim'                 },
    { nome: 'Campus Osório'                  },
    { nome: 'Campus Porto Alegre'            },
    { nome: 'Campus Porto Alegre (Restinga)' },
    { nome: 'Campus Rio Grande'              },
    { nome: 'Campus Sertão'                  },
    { nome: 'Campus Farroupilha'             },
  ])

  ifrn = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Rio Grande do Norte')
  ifrn.campus.create([
    { nome: 'Campus Mossoró' },
  ])

  ifb = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Brasília')
  ifb.campus.create([
    { nome: 'Campus Avançado de São Sebastião'     },
    { nome: 'Campus Avançado de Taguatinga Centro' },
    { nome: 'Campus Brasília'                      },
    { nome: 'Campus Gama'                          },
    { nome: 'Campus Planaltina'                    },
    { nome: 'Campus Samambaia'                     },
    { nome: 'Campus Taguatinga'                    },
  ])

  ifnortedeminas = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Norte de Minas')
  ifnortedeminas.campus.create([
    { nome: 'Campus Araçuaí'       },
    { nome: 'Campus Arinos'        },
    { nome: 'Campus Januária'      },
    { nome: 'Campus Montes Claros' },
    { nome: 'Campus Pirapora'      },
    { nome: 'Campus Salinas'       },
  ])

  ifpi = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Piauí')
  ifpi.campus.create([
    { nome: 'Campus Avançado de Oeiras'            },
    { nome: 'Campus Avançado de Pedro II'          },
    { nome: 'Campus Avançado de São Joao do Piauí' },
    { nome: 'Campus Avançado de Teresina Zona Sul' },
    { nome: 'Campus Corrente'                      },
    { nome: 'Campus Floriano'                      },
    { nome: 'Campus Parnaíba'                      },
    { nome: 'Campus Paulistana'                    },
    { nome: 'Campus Picos'                         },
    { nome: 'Campus Piripiri'                      },
    { nome: 'Campus São Raimundo Nonato'           },
    { nome: 'Campus Teresina'                      },
    { nome: 'Campus Uruçuí'                        },
  ])

  ifam = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Amazonas')
  ifam.campus.create([
    { nome: 'Campus Lábrea'                   },
    { nome: 'Campus Manaus Zona'              },
    { nome: 'Campus Manaus'                   },
    { nome: 'Campus Maués'                    },
    { nome: 'Campus Parintins'                },
    { nome: 'Campus Presidente Fegueiredo'    },
    { nome: 'Campus São Gabriel da Cachoeira' },
    { nome: 'Campus Tabatinga'                },
  ])

  ifpr = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Paraná')
  ifpr.campus.create([
    { nome: 'Campus Avançado de Irati'    },
    { nome: 'Campus Avançado de Ivaiporã' },
    { nome: 'Campus Avançado de Londrina' },
    { nome: 'Campus Avançado de Palmas'   },
    { nome: 'Campus Curitiba'             },
    { nome: 'Campus Foz do Iguaçu'        },
    { nome: 'Campus Jacarezinho'          },
    { nome: 'Campus Paranaguá'            },
    { nome: 'Campus Paranavaí'            },
    { nome: 'Campus Telêmaco Borba'       },
    { nome: 'Campus Umuarama'             },
  ])

  ifap = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Amapá')
  ifap.campus.create([
    { nome: 'Campus Macapá' },
  ])

  ifac = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Acre')
  ifac.campus.create([
    { nome: 'Campus Cruzeiro do Sul' },
    { nome: 'Campus Rio Branco'      },
    { nome: 'Campus Sena Madureira'  },
  ])

  ifma = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Maranhão')
  ifma.campus.create([
    { nome: 'Campus Alcântara'                    },
    { nome: 'Campus Bacabal'                      },
    { nome: 'Campus Barra do Corda'               },
    { nome: 'Campus Barreirinhas'                 },
    { nome: 'Campus Buriticupu'                   },
    { nome: 'Campus Caxias'                       },
    { nome: 'Campus Centro Histórico'             },
    { nome: 'Campus Codó'                         },
    { nome: 'Campus Imperatriz'                   },
    { nome: 'Campus Maracanã'                     },
    { nome: 'Campus Monte Castelo'                },
    { nome: 'Campus Pinheiro'                     },
    { nome: 'Campus Santa Inês'                   },
    { nome: 'Campus São João dos Patos'           },
    { nome: 'Campus São Raimundo das Mangabeiras' },
    { nome: 'Campus Timon'                        },
    { nome: 'Campus Zé Doca'                      },
  ])

  ifrj = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Rio de Janeiro')
  ifrj.campus.create([
    { nome: 'Campus Avançado de Engenheiro Paulo de Frontin' },
    { nome: 'Campus Duque de Caxias' },
    { nome: 'Campus Maracanã'        },
    { nome: 'Campus Nilópolis'       },
    { nome: 'Campus Paracambi'       },
    { nome: 'Campus Pinheiral'       },
    { nome: 'Campus Realengo'        },
    { nome: 'Campus São Gonçalo'     },
    { nome: 'Campus Volta Redonda'   },
  ])

  ifpe = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e  Tecnologia de Pernambuco')
  ifpe.campus.create([
    { nome: 'Campus Barreiros'              },
    { nome: 'Campus Belo Jardim'            },
    { nome: 'Campus Caruaru'                },
    { nome: 'Campus Garanhuns'              },
    { nome: 'Campus Ipojuca'                },
    { nome: 'Campus Pesqueira'              },
    { nome: 'Campus Recife'                 },
    { nome: 'Campus Vitória de Santo Antão' },
  ])

  ifba = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia da Bahia')
  ifba.campus.create([
    { nome: 'Campus Barreiras' },
    { nome: 'Campus Camaçarí' },
    { nome: 'Campus Eunápolis' },
    { nome: 'Campus Feira de Santana' },
    { nome: 'Campus Ilhéus' },
    { nome: 'Campus Irecê' },
    { nome: 'Campus Jacobina' },
    { nome: 'Campus Jequié' },
    { nome: 'Campus Paulo Afonso' },
    { nome: 'Campus Porto Seguro' },
    { nome: 'Campus Salvador' },
    { nome: 'Campus Santo Amaro' },
    { nome: 'Campus Seabra' },
    { nome: 'Campus Simões Filho' },
    { nome: 'Campus Valença' },
    { nome: 'Campus Vitória da Conquista' },
  ])

  ifes = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia do Espírito Santo')
  ifes.campus.create([
    { nome: 'Campus Aracruz'                             },
    { nome: 'Campus Avançado Central Serrano'            },
    { nome: 'Campus Avançado de Guarapari'               },
    { nome: 'Campus Avançado de Piúma'                   },
    { nome: 'Campus Avançado de Venda Nova do Imigrante' },
    { nome: 'Campus Cacheiro de Itapemirim'              },
    { nome: 'Campus Cariacica'                           },
    { nome: 'Campus Colatina'                            },
    { nome: 'Campus Colatina Zona Rural'                 },
    { nome: 'Campus Ibatiba'                             },
    { nome: 'Campus Linhares'                            },
    { nome: 'Campus Nova Venécia'                        },
    { nome: 'Campus Santa Teresa'                        },
    { nome: 'Campus São Mateus'                          },
    { nome: 'Campus Serra'                               },
    { nome: 'Campus Vila Velha'                          },
    { nome: 'Campus Vitória'                             },
  ])

  ifsc = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Santa Catarina')
  ifsc.campus.create([
    { nome: 'Campus Avançado de Caçador'        },
    { nome: 'Campus Avançado de Garopaba'       },
    { nome: 'Campus Avançado de Jaraguá do Sul' },
    { nome: 'Campus Avançado de Palhoça'        },
    { nome: 'Campus Avançado de Urupema'        },
    { nome: 'Campus Avançado de Xanxerê'        },
    { nome: 'Campus Canoinhas'                  },
    { nome: 'Campus Chapecó'                    },
    { nome: 'Campus Continente'                 },
    { nome: 'Campus Criciúma'                   },
    { nome: 'Campus Florianópolis'              },
    { nome: 'Campus Gaspar'                     },
    { nome: 'Campus Itajaí'                     },
    { nome: 'Campus Jaraguá do Sul'             },
    { nome: 'Campus Joinville'                  },
    { nome: 'Campus Lages'                      },
    { nome: 'Campus São José'                   },
    { nome: 'Campus São Miguel do Oeste'        },
  ])

  iffluminense = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Fluminense')
  iffluminense.campus.create([
    { nome: 'Campus Bom Jesus de Itabapoana' },
    { nome: 'Campus Cabo Frio'               },
    { nome: 'Campus Campos Centro'           },
    { nome: 'Campus Campos Guarus'           },
    { nome: 'Campus Itaperuna'               },
    { nome: 'Campus Macaé'                   },
  ])

  ifsudestedeminas = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Sudeste de Minas Gerais')
  ifsudestedeminas.campus.create([
    { nome: 'Campus Avançado de São João del Rei' },
    { nome: 'Campus Barbacena'                    },
    { nome: 'Campus Juiz de Fora'                 },
    { nome: 'Campus Muriaé'                       },
    { nome: 'Campus Rio Pomba'                    },
  ])

  ifgoiano = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Goiano')
  ifgoiano.campus.create([
    { nome: 'Campus Iporá'     },
    { nome: 'Campus Morrinhos' },
    { nome: 'Campus Rio Verde' },
    { nome: 'Campus Urutai'    },
  ])

  iffarroupilha = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Farroupilha')
  iffarroupilha.campus.create([
    { nome: 'Campus Júlio de Castilhos' },
    { nome: 'Campus Panambi'            },
    { nome: 'Campus Santa Rosa'         },
    { nome: 'Campus Santo Augusto'      },
    { nome: 'Campus São Borja'          },
    { nome: 'Campus São Vicente do Sul' },
  ])

  ifgo = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia de Goiás')
  ifgo.campus.create([
    { nome: 'Campus Avançado de Águas Lindas'         },
    { nome: 'Campus Avançado de Aparecida de Goiânia' },
    { nome: 'Campus Avançado de Goiânia Setor Oeste'  },
    { nome: 'Campus Avançado de Goiás'                },
    { nome: 'Campus Formosa'                          },
    { nome: 'Campus Goiânia'                          },
    { nome: 'Campus Inhumas'                          },
    { nome: 'Campus Itumbiara'                        },
    { nome: 'Campus Jataí'                            },
    { nome: 'Campus Luziânia'                         },
    { nome: 'Campus Uruaçu'                           },
  ])

  ifsulriograndense = Instituicao.create(nome: 'Instituto Federal de Educação, Ciência e Tecnologia Sul-Rio Grandense')
  ifsulriograndense.campus.create([
    { nome: 'Pelotas' },
    { nome: 'Sapucaia do Sul' },
    { nome: 'Charqueadas' },
    { nome: 'Passo Fundo' },
    { nome: 'Camaquã' },
    { nome: 'Bagé' },
    { nome: 'Venâncio Aires' },
    { nome: 'Pelotas CAGV' },
  ])

  setecmec = Instituicao.create(nome: 'SETEC/MEC')
  setecmec.campus.create([
    { nome: 'RENAPI' },
  ])
end

criar_instituicoes_e_campus_associados if Instituicao.count == 0
