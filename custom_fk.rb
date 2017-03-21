fks = []
File.open('custom_fk.txt').each_line do |x|
  next if x[0]=='#'
  fks << x.split(',').map{|x| x.strip}
end

fks2 = fks.map do |arr|
  t1, t2, fk = arr
  t1 = t1.singularize
  t2 = t2.singularize
  c1 = Object.const_get(t1.camelize.singularize)
  c2 = Object.const_get(t2.camelize.singularize)
  fk_prefix = fk[0..-4]
  [t1,t2, c1, c2, fk, fk_prefix]
end

$many2 = $many.clone


fks2.each do |arr|
  t1,t2, c1, c2, fk, fk_prefix = arr
  if $belongs2[t1].nil?
    $belongs2[t1] = [t2]
  else
    $belongs2[t1] << t2
  end
  if $belongs[t1].nil?
    $belongs[t1] = [[fk_prefix, c2, fk]]
  else
    $belongs[t1] << [fk_prefix, c2, fk]
  end  
  if $many[t2].nil?
    $many[t2] = [t1]
  else
    $many[t2] << t1
  end
  if $many2[t2].nil?
    $many2[t2] = [[c1,fk]]
  else
    $many2[t2] << [c1,fk]
  end
end
