module Factories   

  Factory.define :user do |u|
    u.login 'bugleboy'
    u.password               'jeans'
    u.password_confirmation  'jeans'
    u.email                  'bb@gmail.com'
  end
    
  Factory.define :bubble do |b|
    b.body 'bubble body'
    b.expire_at 1.day.from_now
  end
   
  Factory.define :bubble_with_code, :class => Bubble do |b|
    b.body 'here is is\n***ruby\ndef my_method\nputs %Q(oh yeah)\nend\n***'
    b.expire_at 2.days.from_now 
  end
  
  Factory.define :another_bubble, :class => Bubble do |b|
    b.body 'bubble from another mother'
    b.expire_at 3.days.from_now
  end     
  
end