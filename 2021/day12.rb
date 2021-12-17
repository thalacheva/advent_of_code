input1 = %w[start-A start-b A-c A-b b-d A-end b-end]
input2 = %w[dc-end
            HN-start
            start-kj
            dc-start
            dc-HN
            LN-dc
            HN-end
            kj-sa
            kj-HN
            kj-dc]

input3 = %w[fs-end
            he-DX
            fs-he
            start-DX
            pj-DX
            end-zg
            zg-sl
            zg-pj
            pj-he
            RW-he
            fs-DX
            pj-RW
            zg-RW
            start-pj
            he-WI
            zg-he
            pj-fs
            start-RW]

input4 = %w[vp-BY
            ui-oo
            kk-IY
            ij-vp
            oo-start
            SP-ij
            kg-uj
            ij-UH
            SP-end
            oo-IY
            SP-kk
            SP-vp
            ui-ij
            UH-ui
            ij-IY
            start-ui
            IY-ui
            uj-ui
            kk-oo
            IY-start
            end-vp
            uj-UH
            ij-kk
            UH-end
            UH-kk]

$map = []

def add(cave1, cave2)
  cave = $map.find { |path| path[:cave] == cave1 }
  if cave
    cave[:links].push(cave2)
  else
    $map.push({ cave: cave1, links: [cave2] })
  end
end

input4.each do |line|
  cave1, cave2 = line.split('-')
  add(cave1, cave2)
  add(cave2, cave1)
end

$paths = []

def can_visit_twice(path, link)
  return false if link == 'start'

  small_caves = path.reject { |c| c.upcase == c }
  small_caves.uniq.length == small_caves.length
end

def find_path(cave_name, path)
  path.push(cave_name)

  if cave_name == 'end'
    $paths.push(path.to_s)
  else
    cave = $map.find { |c| c[:cave] == cave_name }
    cave[:links].each do |link|
      find_path(link, path.clone) if !path.include?(link) ||
                                     link.upcase == link ||
                                     can_visit_twice(path, link)
    end
  end
end

find_path('start', [])

puts $paths
puts "the number of paths is #{$paths.length}"
