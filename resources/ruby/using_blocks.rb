def f1
  yield
  yield
  yield
end

f1 {puts 'Only once, please'}
puts 'I said ONCE!'

def f2
  (1..10).each do |x|
    yield x
  end
end

f2 {|p| puts 'Only once, please ' + p.to_s}

def f3(p1, &block)
  puts p1
  (1..10).each do |x|
    #yield x
    block.call(x)
  end
end

def f4 p1
  puts p1
  (1..10).each do |x|
    yield x
    #block.call(x)
  end
end

def foo(*args, &blk)
 blk.call(args.join(' '))
end

f4('header'){|p| puts 'Only once, please ' + p.to_s}
f4('header') do |p| 
  puts 'Only once, please ' + p.to_s
end


foo('Sidu', 'Ponnappa'){|name| puts "Hello #{name}"}
