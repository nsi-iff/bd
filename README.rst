BD 2.0
======

Instalação
++++++++++

- Bundle install
- É necessário copiar o sam.yml.example e o database.yml.example:
  cp config/sam.yml.example config/sam.yml &&
  cp config/database.yml.example config/database.yml
- rake db:drop:all db:create:all db:migrate db:seed db:test:prepare


Dependências nativas
--------------------

- `webkit <https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit>`_
- Posgresql

Contribuindo
++++++++++++


Instalação do elasticsearch
---------------------------

`Baixe e instale <http://www.elasticsearch.org/guide/reference/setup/installation.html>`_ o elasticsearch.

`Instale <https://github.com/elasticsearch/elasticsearch-mapper-attachments>`_ o plugin elasticsearch-mapper-attachments.

Para executar ou testar a BD é necessário ter uma instância do elasticsearch rodando e referenciada em ``config/elasticsearch.yml``.
Para rodar o elasticsearch, estando na pasta do próprio, digite (se quiser rodar em background, basta omitir o ``-f``)::

    bin/elasticsearch -f


O arquivo de configuração do elasticsearch (meramente uma cópia de ``config/elasticsearch.yml.example``) pode ser gerado com::

    make default_config


O arquivo ``config/elasticsearch.yml`` será ignorado pelo controle de versão, podendo, assim, ser alterado à vontade.


Issues
------
- Assine *uma* issue de cada vez. (Exceção: se as issues assinadas só couberem a você para faze-las.)
- Se finalizou o **obrigatório** da issue, feche-a, se quiser refatorar, incrementar, faça mesmo com a issue fechada,
  não há necessidade de deixá-la aberta ou reabri-la.
- Se quiser alterar algo na issue, faça nos comentários para ficar claro que ela foi alterada, sendo assim,
  quem for fazer a issue deve ler todos os comentários.

Commits
-------
- Assegure-se que os testes estão passando antes do commit.
- Use mensagens curtas e claras.
- Nas mensagens faça referência a issue que o commit está relacionado, ex: "mensagem do commit (#numero_da_issue)"

Boas Práticas
-------------
- Antes de começar a alterar o código, execute um pull e rode os testes, ou no mínimo verifique se os testes estão passando na integração contínua.
- Evite deixar espaços em branco (blank spaces/trailing characters).
- Não use tabs para indentação, mas sim espaços, respeitando a convenção de cada linguagem: `2 espaços <https://github.com/nsi-iff/ruby-style-guide/tree/reduce-over-inject>`_ para Ruby, `4 espaços <http://javascript.crockford.com/code.html>`_ para JavaScript. Na maioria dos editores, é possível configurar de modo que tabs sejam convertidas no número desejado de espaços.

