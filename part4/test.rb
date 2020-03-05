require_relative 'route'
require_relative 'station'
require_relative 'train'
require 'pry'


st1 = Station.new('Kurskaya')
st2 = Station.new('Mikhailovo')
st3 = Station.new('Novokosino')
st4 = Station.new('Lyubertsy')

rt1 = Route.new(st1, st4)
rt2 = Route.new(st2, st1)

rt1.add_intermediate_point(st3)
puts "***" * 20
puts rt1.route_points

TRAIN_TYPES = %(грузовой пассажирский)

tr1 = Train.new('NBA01', TRAIN_TYPES[0], 37)
tr2 = Train.new('NHL02', TRAIN_TYPES[0], 24)
tr3 = Train.new('COVIP19', TRAIN_TYPES[1], 13)


tr1.route = rt1
tr2.route = rt1

tr3.route = rt2

# проверил вагоны и управление скоростью
puts "111" * 20
tr3.increase_speed(50)
tr3.attach_vagon
puts tr3.vagons_count
tr3.detach_vagon
puts tr3.vagons_count
tr3.break_speed(tr3.speed)
tr3.attach_vagon
puts tr3.vagons_count
tr3.detach_vagon
puts tr3.vagons_count

# проверил перемещение поездов и оповещения о ближайших станциях
puts "222" * 20
puts tr1.next_station
tr1.move_forward
puts tr1.next_station
puts tr1.previous_station
tr1.move_backward

# проверил количество поездов на станциях и по типам
puts "333" * 20
puts st1.trains
puts st2.trains
puts "444" * 20
puts st1.trains_by_type(TRAIN_TYPES[0])
puts st2.trains_by_type(TRAIN_TYPES[1])
