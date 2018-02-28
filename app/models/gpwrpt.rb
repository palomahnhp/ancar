class Gpwrpt  < ActiveRecord::Base
  establish_connection GPWRPT_DB
  self.table_name = 'gpw.rpt001'
end