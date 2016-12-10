require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # test "the truth" do
  #   assert true
  # end
  test "product price is valid" do
    product = Product.new(title: "Super awesome product",
                          description: "book lorem awesome ipsum!",
                          image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

#    assert product.errors[:title].any?
#    assert product.errors[:description].any?
#    assert product.errors[:image_url].any?
#    assert product.errors[:price].any?
  end

  def new_product(image_url)
    product = Product.new(title: "Super awesome produt",
                          description: "book lorem awesome ipsum!",
                          price: 1,
                          image_url: image_url)
  end

  test "image url must be valid" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
    http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should be invalid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy", price: 1, image_url: "fred.gif"
                          )
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                  product.errors[:title]
  end
end
