-- CS4400: Introduction to Database Systems: Wednesday, March 8, 2023
-- Flight Management Course Project Mechanics (v1.0) STARTING SHELL
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

use flight_management;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a database-wide unique location if
it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin
	if ip_airlineID is null then leave sp_main; end if;
    if ip_tail_num is null then leave sp_main; end if;
    if ip_speed = 0 then leave sp_main; end if;
    if ip_seat_capacity = 0 then leave sp_main; end if;
    if ((select count(*) from airplane where airlineID = ip_airlineID) <> 0) then
		if ((select count(*) from airplane where tail_num = ip_tail_num) = 0) then
			if ((select count(*) from airplane where locationID = ip_locationID) = 0) then
				if ip_plane_type = 'jet' then
					if ip_jet_engines is not null then
						insert into airplane values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, 
						ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);
					end if;
				elseif ip_plane_type = 'propeller' then
					if ip_skids is not null and ip_propellers is not null then
						insert into airplane values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, 
						ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);
					end if;
				else
					insert into airplane values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, 
						ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);
				end if;
			end if;
		end if;
	end if;
end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a database-wide unique location if it will be used to support
airplane takeoffs and landings.  An airport may have a longer, more descriptive
name.  An airport must also have a city and state designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state char(2), in ip_locationID varchar(50))
sp_main: begin
	if not exists (select * from airport where ip_airportID = airportID) then
		insert into airport(airportID, airport_name, city, state, locationID) values (ip_airportID, ip_airport_name, ip_city, 			ip_state, ip_locationID);
	end if;
end //
delimiter ;
-- call add_airport('SJC', 'San Jose Mineta International Airport', 'San Jose', 'CA', null);

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person may have a first and last name as well.

Also, a person can hold a pilot role, a passenger role, or both roles.  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  Also,
a pilot might be assigned to a specific airplane as part of the flight crew.  As a
passenger, a person will have some amount of frequent flyer miles. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_flying_airline varchar(50), in ip_flying_tail varchar(50),
    in ip_miles integer)
sp_main: begin
	if ((ip_taxID is NULL or ip_experience is NULL) and ip_miles is NULL) 
		then leave sp_main;
	end if;

	if exists (select * from person where personID = ip_personID) then
		leave sp_main;
	end if;
    
	if not exists (select * from person where personID = ip_personID) then
		insert into person (personID, first_name, last_name, locationID) values (ip_personID, ip_first_name, ip_last_name, ip_locationID); 
	end if;
    
    if (ip_taxID and ip_experience is not NULL) then 
		insert into pilot(personID, taxID,
            experience, flying_airline, flying_tail) values (ip_personID, ip_taxID,
            ip_experience, ip_flying_airline, ip_flying_tail);  
	end if;
    
	if (ip_miles is not NULL) then insert into passenger values (ip_personID, ip_miles); end if;
end //
delimiter ;
-- call add_person('p925','Sam','Jones','port_2', '111-28-4786', 4,'American', 'n330ss', 20);

-- [4] grant_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new pilot license.  The license must reference
a valid pilot, and must be a new/unique type of license for that pilot. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_pilot_license;
delimiter //
create procedure grant_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin
    if not exists (select * from pilot where personID = ip_personID) then
        leave sp_main;
    end if;
    insert into pilot_licenses (personID, license) values (ip_personID, ip_license);
end //
delimiter ;

-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  Once
an airplane has been assigned, we must also track where the airplane is along
the route, whether it is in flight or on the ground, and when the next action -
takeoff or landing - will occur. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_airplane_status varchar(100), in ip_next_time time)
sp_main: begin
	if ip_flightID is null then leave sp_main; end if;
    if ip_routeID is null then leave sp_main; end if;
    
    -- if both support_airline and support_tail are null, plane hasn't been assigned
    if (ip_support_airline is null and ip_support_tail is null) and (ip_progress is not null or ip_airplane_status is not null or ip_next_time is not null) then leave sp_main; end if;
    -- if one of support_airline and support_tail are null, we can't add the plane
    if (ip_support_airline is null xor ip_support_tail is null) then leave sp_main; end if;
    if exists (select * from route where routeID = ip_routeID) then
		insert into flight values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress,
        ip_airplane_status, ip_next_time);
	end if;
end //
delimiter ;

-- [6] purchase_ticket_and_seat()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ticket.  The cost of the flight is optional
since it might have been a gift, purchased with frequent flyer miles, etc.  Each
flight must be tied to a valid person for a valid flight.  Also, we will make the
(hopefully simplifying) assumption that the departure airport for the ticket will
be the airport at which the traveler is currently located.  The ticket must also
explicitly list the destination airport, which can be an airport before the final
airport on the route.  Finally, the seat must be unoccupied. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ticket_and_seat;
delimiter //
create procedure purchase_ticket_and_seat (in ip_ticketID varchar(50), in ip_cost integer,
	in ip_carrier varchar(50), in ip_customer varchar(50), in ip_deplane_at char(3),
    in ip_seat_number varchar(50))
sp_main: begin
    -- if customer in ticket is not a valid personID in person table or destination airport is null, then leave
    if exists (select * from ticket where ticketID = ip_ticketID) then
        leave sp_main;
    end if;
    if not exists (select * from person where personID = ip_customer) then
        leave sp_main;
    end if;
    if exists (select * from ticket_seats where seat_number = ip_seat_number) then
		leave sp_main;
	end if;
	
    if ip_deplane_at is not null then
		insert into ticket (ticketID, cost, carrier, customer, deplane_at) values (ip_ticketID, ip_cost, ip_carrier, ip_customer, ip_deplane_at);
		insert into ticket_seats (ticketID, seat_number) values (ip_ticketID, ip_seat_number);
	end if;
end //
delimiter ;

-- [7] add_update_leg()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new leg as specified.  However, if a leg from
the departure airport to the arrival airport already exists, then don't create a
new leg - instead, update the existence of the current leg while keeping the existing
identifier.  Also, all legs must be symmetric.  If a leg in the opposite direction
exists, then update the distance to ensure that it is equivalent.   */
-- -----------------------------------------------------------------------------
drop procedure if exists add_update_leg;
delimiter //
create procedure add_update_leg (in ip_legID varchar(50), in ip_distance integer,
    in ip_departure char(3), in ip_arrival char(3))
sp_main: begin
	if exists (select legID from leg where ip_legID = legID and ip_departure = departure and ip_arrival = arrival) then 
		update leg set distance = ip_distance where ip_legID = legID; 
	end if;
    
	if exists (select legID from leg where ip_departure = arrival and ip_arrival = departure) then 
		update leg set distance = ip_distance where ip_departure = arrival and ip_arrival = departure;
    end if;
    
    if not exists (select legID from leg where ip_legID = legID) then
		insert into leg values (ip_legID, ip_distance, ip_departure, ip_arrival);
	end if;
end //
delimiter ;
-- call add_update_leg('leg_26', 2000, 'LAX', 'ORD');

-- [8] start_route()
-- -----------------------------------------------------------------------------
/* This stored procedure creates the first leg of a new route.  Routes in our
system must be created in the sequential order of the legs.  The first leg of
the route can be any valid leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_route;
delimiter //
create procedure start_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
    if exists (select * from route where routeID = ip_routeID) then
        leave sp_main;
    end if;
    
    if not exists (select * from leg where legID = ip_legID) then
		leave sp_main;
	end if;
    
    -- route only has the routeID field to set that to ip_routeID
    -- in route_path, for the same routeID created in route, set the legID to ip_legID and the the sequence to 1
    insert into route (routeID) values (ip_routeID);
    insert into route_path (routeID, legID, sequence) values (ip_routeID, ip_legID, 1);
end //
delimiter ;
-- call start_route('new_eastbound_west_milk_run','leg_10');

-- [9] extend_route()
-- -----------------------------------------------------------------------------
/* This stored procedure adds another leg to the end of an existing route.  Routes
in our system must be created in the sequential order of the legs, and the route
must be contiguous: the departure airport of this leg must be the same as the
arrival airport of the previous leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists extend_route;
delimiter //
create procedure extend_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
	if not exists (select * from route where routeID = ip_routeID) then leave sp_main; end if;
    if ip_legID is null then leave sp_main; end if;
    IF not exists (select route_path.routeID, leg.arrival, route_path.legID
		from route_path 
		join leg on route_path.legID = leg.legID 
		where route_path.routeID = ip_routeID
		and route_path.sequence = 
        (select max(sequence) from route_path where routeID = ip_routeID)
		and leg.arrival = (
        select departure 
        from leg 
        where legID = ip_legID)) then leave sp_main; end if;
	insert into route_path (routeID, legID, sequence)
		select ip_routeID, ip_legID, coalesce(MAX(rp.sequence), 0) + 1
		from route_path rp
		where rp.routeID = ip_routeID;
end //
delimiter ;

-- [10] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
	if exists (select flightID from flight where ip_flightID = flightID and airplane_status = 'in_flight') then 
		update flight set airplane_status = 'on_ground' where ip_flightID = flightID;
        update flight set next_time = (next_time + 10000) % 240000 where ip_flightID = flightID;
        set @support_airline = (select support_airline from flight where ip_flightID = flightID);
		set @support_tail = (select support_tail from flight where ip_flightID = flightID);
		update pilot set experience = experience + 1 where @support_tail = pilot.flying_tail and @support_airline = pilot.			flying_airline;
        set @route = (select routeID from flight where ip_flightID = flightID);
        set @progress = (select progress from flight where ip_flightID = flightID);
        update passenger set miles = miles + (select distance from leg where leg.legID in (select legID from route_path where route_path.routeID = @route and route_path.sequence = @progress)) where passenger.personID in (select customer from ticket where ip_flightID = carrier);
	end if;
end //
delimiter ;
-- call flight_landing('SW_1776');

-- [11] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that propeller driven planes have at least one pilot
assigned, while jets must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
	if exists (select * from flight where flightID = ip_flightID and flight.airplane_status = 'in_flight') then
		leave sp_main;
	end if;

	set @flying_tail = (select support_tail from flight where flightID = ip_flightID);
	set @distance = (select distance
	 from route_path join leg on route_path.legID = leg.legID
	 where routeID = (select routeID from flight where flightID = ip_flightID)
	 and sequence = ((select progress from flight where flightID = ip_flightID) + 1));

	set @speed = (select speed from airplane where tail_num = 
	(select support_tail from flight where flightID = ip_flightID));

	set @next_time = @distance / @speed;
	set @flight_time = sec_to_time(@next_time* 3600);

	set @nt = (select next_time from flight where flightID = ip_flightID);

	set @plane_type = (select plane_type from airplane where tail_num = @flying_tail);
	set @assigned_pilots = (select count(*) from pilot where flying_tail = @flying_tail);
	if (@plane_type = 'jet' and @assigned_pilots >= 2) or (@plane_type = 'prop' and @assigned_pilots >= 1) then
		UPDATE flight SET next_time = ADDTIME(@flight_time, @nt),
		progress = progress + 1,
		airplane_status = 'in_flight'
		where flightID = ip_flightID;
	else 
		set @delay_time = sec_to_time(1800);
		UPDATE flight SET next_time = ADDTIME(@delay_time, @nt);
end if;
end //
delimiter ;
-- call flight_takeoff('DL_1174');

-- [12] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the airport and hold a valid ticket
for the flight. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
    if exists (select * from flight where flightID = ip_flightID and flight.airplane_status != 'in_flight') then
        update person
        set locationID = (select locationID from airplane where tail_num = (select support_tail from flight where flightID = ip_flightID))
        where personID in (select customer from ticket where carrier = ip_flightID) and locationID in
			(select locationID from flight, route_path, leg, airport where flight.flightID = ip_flightID and flight.routeID = route_path.routeID and flight.progress+1 = route_path.sequence and route_path.legID = leg.legID and leg.departure = airport.airportID);
    end if;
end //
delimiter ;

-- [13] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
	if ip_flightID is null then leave sp_main; end if;
	if exists (select * from flight where flightID = ip_flightID and airplane_status = 'on_ground') then
		update person
        set locationID = (select locationID from airport where airportID = 
			(select arrival from leg join route_path on leg.legID = route_path.legID
			join flight on route_path.routeID = flight.routeID
			where sequence = progress and flight.flightID = ip_flightID))
        where personID in (select customer from ticket where carrier = ip_flightID and deplane_at in
			(select arrival from leg where legID in
				(select legID from route_path join flight on route_path.routeID = flight.routeID
					where sequence = progress and flightID = ip_flightID)));
	end if;
end //
delimiter ;

-- call passengers_disembark('AM_1523');

-- [14] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
airplane.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), ip_personID varchar(50))
sp_main: begin
    -- if pilot doesn't have license to that plane, then leave the procedure
    if not exists (select * from pilot_licenses where personID = ip_personID and license = (select plane_type from airplane where tail_num = (select support_tail from flight where flightID = ip_flightID))) then
        leave sp_main;
    end if;

    -- check if pilot is already flying a plane by seeing if pilot.flying_airline and pilot.flying_tail are not null
    if exists (select * from pilot where personID = ip_personID and flying_airline is not null and flying_tail is not null) then
        leave sp_main;
    end if;
    
    -- check if pilot is at the same location as the flight
    if not exists (select * from person right join pilot on pilot.personID = person.personID where locationID in 
		(select locationID from flight, route_path, leg, airport where flight.airplane_status = 'on_ground' and flight.flightID = ip_flightID and flight.routeID = route_path.routeID and flight.progress = route_path.sequence and route_path.legID = leg.legID and leg.departure = airport.airportID)) THEN
        leave sp_main;
	end if;
        
    update pilot
    set flying_airline = (select airlineID from airplane where tail_num = (select support_tail from flight where flightID = ip_flightID)),
        flying_tail = (select tail_num from airplane where tail_num = (select support_tail from flight where flightID = ip_flightID))
    where personID = ip_personID;
    
    -- update the person table by setting the locationID to the locationID from the flight table by matching the flightID with the ip_flightID
    update person
    set locationID = (select locationID from airplane where tail_num = (select support_tail from flight where flightID = ip_flightID))
    where personID = ip_personID;
end //
delimiter ;

-- [15] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
	set @flying_airline = (select support_airline from flight where flightID = ip_flightID);
	set @flying_tail = (select support_tail from flight where flightID = ip_flightID);
	set @current_progress = (select progress from flight where flightID = ip_flightID);
    set @sequence = (select max(sequence) from flight, route_path where flightID = ip_flightID and flight.routeID = route_path.routeID group by flight.routeID);
	
	if (@current_progress != @sequence) then
		leave sp_main;
	end if;
    
    set @flight_location = (select locationID from flight, airplane where flight.flightID = ip_flightID and flight.support_airline = airplane.airlineID and flight.support_tail = airplane.tail_num);
    	if (@flight_location is null) then
		leave sp_main;
	end if;
    
	set @passenger_count = (select count(personID) from person where personID in (select personID from flight, ticket, person where ip_flightID = ticket.carrier and ticket.customer = person.personID group by personID) and locationID = @flight_location);
	if (@passenger_count != 0) then
		leave sp_main;
	end if;
	
    set @final_location = (select locationID from flight, route_path, leg, airport where flight.airplane_status = 'on_ground'and flight.flightID = ip_flightID and flight.routeID = route_path.routeID and flight.progress = route_path.sequence and route_path.legID = leg.legID and leg.arrival = airport.airportID);
							
    update person 
    set locationID = @final_location
    where personID in (select personID from pilot where flying_airline = @flying_airline and flying_tail = @flying_tail);
    
    update pilot
    set flying_airline = null, flying_tail = null
    where flying_airline = @flying_airline and flying_tail = @flying_tail;
end //
delimiter ;

-- update flight set progress = 3 where flightID = 'AM_1523';
-- update person set locationID = 'port_5' where personID in ('p26', 'p40', 'p41');
-- call recycle_crew('AM_1523');

-- [16] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
    -- we need to check if the airplane_status is on_ground and the progress is 0 or the max(sequence) by matching routeID from flight to routeID in route_path
    if exists (select * from flight where flightID = ip_flightID and airplane_status = 'on_ground' and (progress = 0 or progress = (select max(sequence) from route_path where routeID = (select routeID from flight where flightID = ip_flightID)))) then
        delete from flight where flightID = ip_flightID;
    end if;
end //
delimiter ;

-- [17] remove_passenger_role() Done
-- -----------------------------------------------------------------------------
/* This stored procedure removes the passenger role from person.  The passenger
must be on the ground at the time; and, if they are on a flight, then they must
disembark the flight at the current airport.  If the person had both a pilot role
and a passenger role, then the person and pilot role data should not be affected.
If the person only had a passenger role, then all associated person data must be
removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_passenger_role;
delimiter //
create procedure remove_passenger_role (in ip_personID varchar(50))
sp_main: begin
	if ip_personID is null then leave sp_main; end if;
    
	if exists (select * from passenger where personID = ip_personID) then
		if not exists (select * from ticket join flight on carrier = flightID where customer = ip_personID and airplane_status = 'in_flight') then
			delete from ticket where customer = ip_personID;
			delete from passenger where personID = ip_personID;
			if not exists (select * from pilot where personID = ip_personID) then
				delete from person where personID = ip_personID;
			end if;
		end if;
	end if;
end //
delimiter ;

-- [18] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the pilot role from person.  The pilot must not
be assigned to a flight; or, if they are assigned to a flight, then that flight
must either be at the start or end of its route.  If the person had both a pilot
role and a passenger role, then the person and passenger role data should not be
affected.  If the person only had a pilot role, then all associated person data
must be removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role; # not done!
delimiter //
create procedure remove_pilot_role (in ip_personID varchar(50))
sp_main: begin 
	if ip_personID is null then leave sp_main; end if;
    if exists (select * from pilot where personID = ip_personID and flying_tail is not null) then
		if not exists (select * from flight join pilot on flight.support_tail= pilot.flying_tail
			where personID = ip_personID and airplane_status = 'on_ground' and progress in
            (select max(sequence) from route_path where routeID in
            (select routeID from flight join pilot on support_tail = flying_tail
				where personID = ip_personID))) then
			if not exists (select * from flight join pilot on flight.support_tail = pilot.flying_tail
				where progress = 0 and personID = ip_personID) then
				leave sp_main; end if;
		end if;
    end if;
    delete from pilot_licenses where personID = ip_personID;
	delete from pilot where personID = ip_personID;
		if not exists (select * from passenger where personID = ip_personID) then
			delete from person where personID = ip_personID;
		end if;
end //
delimiter ;

-- [19] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air (departing_from, arriving_at, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as
  select leg.departure as departing_from, leg.arrival as arriving_at, count(flight.flightID) as num_flights, group_concat(flightID) as flight_list, min(flight.next_time) as earliest_arrival,
    max(flight.next_time) as latest_arrival, airplane.locationID as airplane_list
  from flight join route_path on flight.routeID = route_path.routeID join leg on route_path.legID = leg.legID join airplane on airplane.tail_num = flight.support_tail
  where airplane_status = 'in_flight' and flight.progress = route_path.sequence 
  group by leg.departure, leg.arrival, airplane.locationID;

-- select * from flights_in_the_air;

-- [20] flights_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are located. We need to
display what airports these flights are departing from, how many flights are departing from
each airport, the list of flights departing from each airport, the earliest and latest arrival time
amongst all of these flights at each airport, and the list of planes (by their location id) that are
departing from each airport. */
-- -----------------------------------------------------------------------------
create or replace view flights_on_the_ground (departing_from, num_flights,
    flight_list, earliest_arrival, latest_arrival, airplane_list) as 
select 
    leg.departure AS departing_from, 
    COUNT(flightID) AS num_flights, 
    GROUP_CONCAT(flightID) AS flight_list, 
    MIN(flight.next_time) AS earliest_arrival, 
    MAX(flight.next_time) AS latest_arrival, 
    airplane.locationID AS airplane_list
from flight 
    join route_path on flight.routeID = route_path.routeID
    join leg on route_path.legID = leg.legID 
    join airplane on airplane.tail_num = flight.support_tail
where flight.airplane_status = 'on_ground' and flight.progress + 1 = route_path.sequence
group by 
    leg.departure, 
    airplane.locationID;

-- [21] people_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. We need to display
what airports these people are departing from, what airports they are arriving at, the list of
planes (by the location id) flying these people, the list of flights these people are on, the earliest
and latest arrival times of these people, the number of these people that are pilots, the number
of these people that are passengers, the number of people on the airplane, and the list of these
people by their person id. */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
    select leg.departure as departing_from, leg.arrival as arriving_at, count(distinct(tail_num)) as num_airplanes, 
		person.locationID as airplane_list, flight.flightID as flight_list, min(flight.next_time) as earliest_arrival, 
        max(flight.next_time) as latest_arrival, count(distinct(pilot.personID)) as num_pilots, 
        count(distinct(passenger.personID)) as num_passengers, count(distinct(person.personID)) as joint_pilots_passengers, 
        group_concat(distinct(person.personID)) as person_list
    from flight join airplane on flight.support_tail = airplane.tail_num
		join route_path on flight.routeID = route_path.routeID
        join leg on route_path.legID = leg.legID
        join ticket on flight.flightID = ticket.carrier
        join person on airplane.locationID = person.locationID
        left join pilot on person.personID = pilot.personID
        left join passenger on person.personID = passenger.personID
    where airplane_status = 'in_flight' and route_path.sequence = flight.progress
    group by leg.departure, leg.arrival, person.locationID, flight.flightID;
    
-- select null, null, 0, null, null, null, null, 0, 0, null, null;

-- [22] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
	select airportID as departing_from, airport.locationID as airport, airport_name, 
		city, state, count(distinct(pilot.personID)) as num_pilots, 
        count(distinct(passenger.personID)) as num_passengers, count(distinct(person.personID)) as joint_pilots_passengers, 
        group_concat(distinct(person.personID)) as person_list
    from airport join person on airport.locationID = person.locationID
        left join pilot on person.personID = pilot.personID
        left join passenger on person.personID = passenger.personID
    where person.locationID = airport.locationID
    group by airport.airportID, person.locationID;
-- select * from people_on_the_ground;

-- [23] route_summary()
-- -----------------------------------------------------------------------------
/* This view describes how the routes are being utilized by different flights. */
-- -----------------------------------------------------------------------------
create or replace view route_info (route, num_legs, leg_sequence, route_length, airport_sequence) as 
	select route_path.routeID as route, count(route_path.legID) as num_legs, 
		group_concat(route_path.legID order by route_path.sequence) as leg_sequence, sum(leg.distance) as route_length, 
        group_concat(leg.departure, '->', leg.arrival order by route_path.sequence) as airport_sequence 
        from route_path join leg on route_path.legID = leg.legID
		group by route_path.routeID;

create or replace view flight_route (route, num_flights, flight_list) as 
	select route_path.routeID as route, count(distinct(flight.flightID)) as num_flgihts, 
		group_concat(distinct(flight.flightID)) as flight_list
        from route_path left join flight on route_path.routeID = flight.routeID
        group by route_path.routeID;

create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as 
    select route_info.route, route_info.num_legs, route_info.leg_sequence, route_info.route_length, flight_route.num_flights,
		flight_route.flight_list, route_info.airport_sequence
        from route_info join flight_route on route_info.route = flight_route.route;
-- select * from route_summary;

-- [24] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, num_airports,
	airport_code_list, airport_name_list) as
	select 
		city, 
		state, 
		count(airportID) as num_airports, 
		group_concat(airportID order by airportID) as airport_code_list, 
		group_concat(airport_name order by airportID) as airport_name_list 
	from airport 
	group by city, state 
	having count(*) > 1;

-- [25] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle. The flight with the
smallest next time in chronological order must be identified and selected.

If multiple flights have the same time, then flights that are landing should be preferred over
flights that are taking off. Similarly, flights with the lowest identifier in alphabetical order
should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed to land,
passengers allowed to disembark, and the time advanced by one hour until the next takeoff to
allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should be allowed to
board, and the time should be advanced to represent when the airplane will land at its next
location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the flight crew should
be recycled to allow rest, and the flight itself should be retired from the system.
Hint: You may find it helpful to call some of the stored procedures you have already written. */
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle ()
sp_main: begin
    DECLARE next_flight_id VARCHAR(50);
    DECLARE next_flight_time TIME;
    DECLARE next_flight_leg VARCHAR(50);
    DECLARE next_flight_status VARCHAR(50);
    DECLARE next_flight_type VARCHAR(50);
    DECLARE next_flight_route VARCHAR(50);
    DECLARE next_route_id VARCHAR(50);
    DECLARE next_progress INT;
    DECLARE end_of_route INT;
    
    SELECT 
        flight.flightID,
        flight.routeID,
        flight.airplane_status,
        flight.progress
    INTO next_flight_id, next_route_id, next_flight_status, next_progress
    FROM
        flight
    LEFT JOIN
        route_path ON flight.routeID = route_path.routeID
            AND flight.progress + 1 = route_path.sequence
    JOIN leg
        ON leg.legID = route_path.legID
    ORDER BY next_time ASC , flight.flightID ASC
    LIMIT 1;
        
    SET @end_of_route = (SELECT 
        MAX(sequence)
        FROM
        route_path
        WHERE route_path.routeID = next_route_id
    GROUP BY routeID);
        

    IF next_flight_status = 'in_flight' THEN
        CALL flight_landing(next_flight_id);
    ELSEIF next_flight_status = 'on_ground' and next_progress < @end_of_route THEN
        CALL flight_takeoff(next_flight_id);
    ELSE
        CALL retire_flight(next_flight_id);
    END IF;
end //
delimiter ;

