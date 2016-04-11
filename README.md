# ANCAR
Aplicación para el análisis de la carga de trabajo de las unidades municipales 

## Estado del proyecto

Inicio el desarrollo de esta aplicación [05 de abril de 2016]
La evolución y futura lista de funcionalidades a implementar se pueden consultar en la lista de [tareas por hacer](https://github.com/IAMCorporativos/ANCAR).

## Tecnología

El backend de esta aplicación se desarrolla con el lenguaje de programación [Ruby](https://www.ruby-lang.org/) sobre el *framework* [Ruby on Rails](http://rubyonrails.org/).
Los estilos de la página usan [SCSS](http://sass-lang.com/) sobre [Foundation](http://foundation.zurb.com/)

## Configuración para desarrollo y tests

Prerequisitos: tener instalado git, Ruby 2.2.3, la gema `bundler`, ghostscript y PostgreSQL (9.4 o superior).

```

git clone https://github.com/IAMCorporativos/ANCAR
cd ANCAR
bundle install
cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml
rake db:create
bin/rake db:setup
bin/rake db:dev_seed
RAILS_ENV=test bin/rake db:setup
```

Para ejecutar la aplicación en local:
```
bin/rails s
```

Prerequisitos para los tests: tener instalado PhantomJS >= 2.0

Para ejecutar los tests:

```
bin/rspec
```
