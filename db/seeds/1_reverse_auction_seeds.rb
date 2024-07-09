rich_text = "<div>
  Lorem ipsum dolor sit, amet consectetur adipisicing elit.
  Temporibus molestiae odit placeat fuga laborum explicabo
  soluta autem labore, blanditiis iusto totam illo.
  Inventore vitae doloremque quod dolore velit dolor hic.
  Lorem ipsum dolor sit, amet consectetur adipisicing elit.
  Temporibus molestiae odit placeat fuga laborum explicabo
  soluta autem labore, blanditiis iusto totam illo. 
  Inventore vitae doloremque quod dolore velit dolor hic.
  Lorem ipsum dolor sit, amet consectetur adipisicing elit. 
  Temporibus molestiae odit placeat fuga laborum explicabo
  soluta autem labore, blanditiis iusto totam illo. 
  Inventore vitae doloremque quod dolore velit dolor hic.
  <br><br>
  Lorem ipsum dolor sit, amet consectetur adipisicing elit.
  Temporibus molestiae odit placeat fuga laborum explicabo
  soluta autem labore, blanditiis iusto totam illo.
  Inventore vitae doloremque quod dolore velit dolor hic.
  Lorem ipsum dolor sit, amet consectetur adipisicing elit.
  Temporibus molestiae odit placeat fuga laborum explicabo
  soluta autem labore, blanditiis iusto totam illo.
  Inventore vitae doloremque quod dolore velit dolor hic.
  Lorem ipsum dolor sit, amet consectetur adipisicing elit.
  Temporibus molestiae odit placeat fuga laborum explicabo
  soluta autem labore, blanditiis iusto totam illo. 
  Inventore vitae doloremque quod dolore velit dolor hic.
</div>"

def auction(company)
  Auction.new(
    title: FFaker::Conference.name,
    description: rich_text,
    collaborator: company,
    starts_at: Time.zone.now,
    closes_at: 5.days.from_now
  )
end

def lot(auction)
  Lot.new(
    title: FFaker::Product.product_name,
    description: FFakerLorem.paragraph,
    asking_price: rand(700),
    collaborator: auction.collaborators.first,
    auction: auction
  )
end

Company.all do |company|
  25.times do
    auction(company).save!
  end
end

Auction.all.each do |auction|
  100.times do
    lot(auction).save!
  end
end

Company.all do |company|
  Lot.all.limit(10) do |lot|
    Collection.create(company: company, collectable: lot)
  end
end
