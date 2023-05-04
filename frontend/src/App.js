import AddAirplane from "procedures/AddAirplane";
import AddAirport from "procedures/AddAirport";
import AddPerson from "procedures/AddPerson";
import AddUpdateLeg from "procedures/AddUpdateLeg";
import AssignPilot from "procedures/AssignPilot";
import ExtendRoute from "procedures/ExtendRoute";
import FlightLanding from "procedures/FlightLanding";
import FlightTakeoff from "procedures/FlightTakeoff";
import GrantPilotLicense from "procedures/GrantPilotLicense";
import OfferFlight from "procedures/OfferFlight";
import PassengersBoard from "procedures/PassengersBoard";
import PassengersDisembark from "procedures/PassengersDisembark";
import PurchaseTicketAndSeat from "procedures/PurchaseTicketAndSeat";
import RecycleCrew from "procedures/RecycleCrew";
import RemovePassengerRole from "procedures/RemovePassengerRole";
import RemovePilotRole from "procedures/RemovePilotRole";
import RetireFlight from "procedures/RetireFlight";
import SimulationCycle from "procedures/SimulationCycle";
import StartRoute from "procedures/StartRoute";
import { useState } from "react";
import Collapsible from "react-collapsible";
import "./App.css";
import SelectTable from "./views/SelectTable";

const App = () => {
  const [table, setTable] = useState("airline");
  const [key, setKey] = useState(0);

  const handleTableChange = (event) => {
    setTable(event.target.value);
    setKey(key + 1);
  };

  return (
    <div className="App">
      <h1>Flight Management</h1>
      <select value={table} onChange={handleTableChange}>
        <optgroup label="Tables">
          <option value="airline">airline</option>
          <option value="airplane">airplane</option>
          <option value="airport">airport</option>
          <option value="flight">flight</option>
          <option value="leg">leg</option>
          <option value="location">location</option>
          <option value="passenger">passenger</option>
          <option value="person">person</option>
          <option value="pilot">pilot</option>
          <option value="pilot_licenses">pilot_licenses</option>
          <option value="route">route</option>
          <option value="route_path">route_path</option>
          <option value="ticket">ticket</option>
          <option value="ticket_seats">ticket_seats</option>
        </optgroup>
        <optgroup label="Views (19-24)">
          <option value="flights_in_the_air">19. flights_in_the_air</option>
          <option value="flights_on_the_ground">
            20. flights_on_the_ground
          </option>
          <option value="people_in_the_air">21. people_in_the_air</option>
          <option value="people_on_the_ground">22. people_on_the_ground</option>
          <option value="route_summary">23. route_summary</option>
          <option value="alternative_airports">24. alternative_airports</option>
        </optgroup>
      </select>
      {/* button to refresh the table */}
      <button onClick={() => setKey(key + 1)}>Refresh</button>
      <h3>{table}</h3>
      <SelectTable currentTable={table} key={key} />
      <br />
      <Collapsible trigger="1: Add Airplane">
        <AddAirplane />
      </Collapsible>
      <Collapsible trigger="2: Add Airport">
        <AddAirport />
      </Collapsible>
      <Collapsible trigger="3: Add Person" open={false}>
        <AddPerson />
      </Collapsible>
      <Collapsible trigger="4. Grant Pilot License" open={false}>
        <GrantPilotLicense />
      </Collapsible>
      <Collapsible trigger="5. Offer Flight">
        <OfferFlight />
      </Collapsible>
      <Collapsible trigger="6. Purchase Ticket And Seat">
        <PurchaseTicketAndSeat />
      </Collapsible>
      <Collapsible trigger="7. Add Update Leg">
        <AddUpdateLeg />
      </Collapsible>
      <Collapsible trigger="8. Start Route">
        <StartRoute />
      </Collapsible>
      <Collapsible trigger="9. Extend Route">
        <ExtendRoute />
      </Collapsible>
      <Collapsible trigger="10. Flight Landing">
        <FlightLanding />
      </Collapsible>
      <Collapsible trigger="11. Flight Takeoff">
        <FlightTakeoff />
      </Collapsible>
      <Collapsible trigger="12. Passengers Board">
        <PassengersBoard />
      </Collapsible>
      <Collapsible trigger="13. Passengers Disembark">
        <PassengersDisembark />
      </Collapsible>
      <Collapsible trigger="14. Assign Pilot">
        <AssignPilot />
      </Collapsible>
      <Collapsible trigger="15. Recycle Crew">
        <RecycleCrew />
      </Collapsible>
      <Collapsible trigger="16. Retire Flight">
        <RetireFlight />
      </Collapsible>
      <Collapsible trigger="17. Remove Passenger Role">
        <RemovePassengerRole />
      </Collapsible>
      <Collapsible trigger="18. Remove Pilot Role">
        <RemovePilotRole />
      </Collapsible>
      <Collapsible trigger="25. Simulation Cycle">
        <SimulationCycle />
      </Collapsible>

      {/* TODO: Update table button and change backend to parseInt */}
    </div>
  );
};

export default App;

{
  /*  */
}
{
  /* <AddPerson />
 <OfferFlight />
 <PurchaseTicketAndSeat />
 <AddUpdateLeg />
 <StartRoute />
 <ExtendRoute />
 <FlightLanding />
 <FlightTakeoff />
 <PassengersBoard />
 <PassengersDisembark />
 <AssignPilot />
 <RecycleCrew />
 <RetireFlight />
 <RemovePassengerRole />
 <RemovePilotRole /> */
}
