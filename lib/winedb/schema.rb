# encoding: UTF-8

module WineDb

class CreateDb < ActiveRecord::Migration


def up

create_table :wines do |t|
  t.string  :key,     null: false   # import/export key
  t.string  :title,   null: false
  t.string  :synonyms  # comma separated list of synonyms

  t.string  :web    # optional url link (e.g. )
  t.integer :since  # optional year (e.g. 1896)

  ## check: why decimal and not float? 
  t.decimal    :abv    # Alcohol by volume (abbreviated as ABV, abv, or alc/vol) e.g. 4.9 %

  t.references :winery   # optional (for now)


  t.string  :txt            # source ref
  t.boolean :txt_auto, null: false, default: false     # inline? got auto-added?


  t.references :country, null: false
  t.references :region   # optional
  t.references :city     # optional

  t.timestamps
end


create_table :wineries do |t|
  t.string  :key,      null: false   # import/export key
  t.string  :title,    null: false
  t.string  :synonyms  # comma separated list of synonyms
  t.string  :address
  t.integer :since
  ## renamed to founded to since
  ## t.integer :founded  # year founded/established    - todo/fix: rename to since? 
  t.integer :closed  # optional;  year winery closed

  t.integer :area    # in ha e.g. 8 ha   # Weingarten/rebflaeche

  # use stars in .txt e.g. # ***/**/*/- => 1/2/3/4
  t.integer :grade, null: false, default: 4


  t.string  :txt            # source ref
  t.boolean :txt_auto, null: false, default: false     # inline? got auto-added?

  t.string  :web        # optional web page (e.g. www.ottakringer.at)
  t.string  :wikipedia  # optional wiki(pedia page)


  t.references :country,  null: false
  t.references :region   # optional
  t.references :city     # optional
  
  t.timestamps
end

end # method up

def down
  raise ActiveRecord::IrreversibleMigration
end


end # class CreateDb

end # module WineDb
