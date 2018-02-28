class Gpwrpt  < ActiveRecord::Base
  establish_connection GPWRPT_DB
=begin
  establish_connection({
      adapter: 'sqlserver',
      mode: 'dblib',
      host: '10.90.51.153',
      port: '2685',
      username: 'GPNUSUU',
      password: 'jg17PR9x',
      database: 'GPWRPT'
                       })
=end
  self.table_name = 'gpw.rpt001'
end