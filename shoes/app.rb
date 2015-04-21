require 'green_shoes'

# Shoes.app do
#    stack width: self.width, height: self.height, scroll: true do
#      background "#DFA"
#      100.times do |i|
#        para "Paragraph No. #{i}"
#      end
#      flush
#    end
#  end

# Shoes.app do
#   stack :margin => 10 do
#     @edit = edit_box do
#       @para.text = @edit.text
#     end
#     @para = para ""
#   end
# end

Shoes.app(title: "My calculator", width: 200, height: 240) do
  flow width: 200, height: 240 do
    flow width: 0.7, height: 0.2 do
      background rgb(0, 157, 228)
    end

    flow width: 0.3, height: 0.2 do
    end

    flow width: 1.0, height: 0.8 do
      background rgb(139, 206, 236)
    end
  end
end

class Messenger
  def initialize(slot)
    @slot = slot
    @para.text = 'hello world'
    @slot.app do
      @para = para ''
    end
  end

  def add_new(msg)
    @slot.app do
      @message.text = msg
    end
  end
end

# Shoes.app do
#   slot = stack
#   m = Messenger.new(slot)
#   # button "change" do
#   #   m.add_new("this changed!")
#   # end
# end

# class Messenger
#   def initialize slot
#     @slot = slot
#   end
#   def add msg
#     @slot.app do
#       para msg rescue puts $!
#     end
#   end
# end
# Shoes.app do
#   slot = stack
#   m = Messenger.new slot
#   m.add 'hello'
# end
