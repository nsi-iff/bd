# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120208041723) do

  create_table "autores", :force => true do |t|
    t.string   "nome"
    t.string   "lattes"
    t.integer  "conteudo_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "conteudos", :force => true do |t|
    t.string   "titulo"
    t.string   "link"
    t.string   "arquivo"
    t.string   "grande_area_de_conhecimento"
    t.string   "area_de_conhecimento"
    t.string   "campus"
    t.text     "direitos"
    t.text     "resumo"
    t.string   "type"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "subtitulo"
    t.string   "nome_evento"
    t.string   "local_evento"
    t.integer  "numero_evento"
    t.integer  "ano_evento"
    t.string   "editora"
    t.integer  "ano_publicacao"
    t.string   "local_publicacao"
    t.string   "titulo_anais"
    t.integer  "pagina_inicial"
    t.integer  "pagina_final"
    t.string   "nome_periodico"
    t.string   "fasciculo"
    t.integer  "volume_publicacao"
    t.integer  "data_publicacao"
    t.boolean  "traducao",                    :default => false
    t.integer  "numero_edicao"
    t.integer  "numero_paginas"
  end

end
