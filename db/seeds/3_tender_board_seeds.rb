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

def tender(rich_text)
  tender = Tender.new(
    title: FFaker::Lorem.word,
    description: rich_text,
    deadline: 10.days.from_now,
    organisation: FFaker::Company.name,
    administrator: Administrator.last,
    location: FFaker::Address.city
  )
  tender.save!

  5.times do
    Tag.create(title: FFaker::Name.first_name, taggable: tender)
  end
end

45.times { tender(rich_text) }

Company.all do |company|
  Tender.all.limit(10) do |tender|
    Collection.create(company: company, collectable: tender)
  end
end
