require 'test_helper'


class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price most be positive" do
    product = Product.new(title: "My book Title",
                          description: "yyy",
                          image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]
    
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end
  
  test "product is not valid without a unique title - i18n" do
    product = Product.new(title:       products(:ruby).title,
                          description: "yyy", 
                          price:       1, 
                          image_url:   "fred.gif")

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
  
  #  image test
  
  def new_product(image_url)
    Product.new(title:    "My Book Title",
                description: "yyy",
                price: 1,
                image_url: image_url)
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.jpg
    http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
    
                            
end
