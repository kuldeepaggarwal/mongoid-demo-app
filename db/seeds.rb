Product.where(title: 'Dell Studio XPS 16',
  description: %{<p>Blending power with elegance, 
    the Dell Studio XPS 16 delivers the ultimate multimedia laptop experience, 
    providing superb performance and design</p>},
  image_url: '1.jpg',
  price: 2299.00 ).first_or_create


User.destroy_all
User.where(:uname => 'admin', :password => "123456").first_or_create