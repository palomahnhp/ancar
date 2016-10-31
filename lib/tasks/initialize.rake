namespace :initialize do

  desc "Initializa summary_types"
  task summary_types: :environment do
    TotalIndicator.update_all(summary_type_id: nil)
    SummaryType.delete_all
    Item.where(item_type: "summary_type").delete_all

    process     = Item.create!(item_type: "summary_type", description: "Proceso", updated_by: "initialize")
    subprocess  = Item.create!(item_type: "summary_type", description: "Subproceso", updated_by: "initialize")
    stock       = Item.create!(item_type: "summary_type", description: "Stock", updated_by: "initialize")
    sub_subprocess = Item.create!(item_type: "summary_type", description: "Sub-subproceso", updated_by: "initialize")
    control     = Item.create!(item_type: "summary_type", description: "Control", updated_by: "initialize")

    pr = SummaryType.create(acronym: "P", item_id:process.id,     order: 1, updated_at: 'initialize')
    s  = SummaryType.create(acronym: "S", item_id:subprocess.id,  order: 2, updated_at: 'initialize')
    u  = SummaryType.create(acronym: "U", item_id:stock.id,       order: 4, updated_at: 'initialize')
    g  = SummaryType.create(acronym: "G", item_id:sub_subprocess.id, order: 3, updated_at: 'initialize')
    c  = SummaryType.create(acronym: "C", item_id:control.id,     order: 5, updated_at: 'initialize')

    TotalIndicator.where(indicator_type: "P").update_all(summary_type_id: pr.id)
    TotalIndicator.where(indicator_type: "S").update_all(summary_type_id: s.id)
    TotalIndicator.where(indicator_type: "U").update_all(summary_type_id: u.id)
    TotalIndicator.where(indicator_type: "G").update_all(summary_type_id: g.id)
    TotalIndicator.where(indicator_type: "C").update_all(summary_type_id: c.id)

  end
end
