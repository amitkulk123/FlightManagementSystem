import { useEffect, useState } from "react";
import api from "../components/api";
import "../components/components.css";

const AddAirplane = () => {
  const [formData, setFormData] = useState({
    airlineID: "Delta",
    tail_num: "n120jn",
    seat_capacity: "10",
    speed: "350",
    locationID: "NULL",
    plane_type: "jet",
    skids: "NULL",
    propellers: "NULL",
    jet_engines: "4",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => {
      const newData = { ...prevData, [name]: value };
      return newData;
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await api.post("/addAirplane", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <div>
            <label htmlFor="airlineID">airlineID</label>
            <input
              type="text"
              id="airlineID"
              name="airlineID"
              value={formData.airlineID}
              onChange={handleChange}
            />
          </div>
          <label htmlFor="tail_num">tail_num</label>
          <input
            type="text"
            id="tail_num"
            name="tail_num"
            value={formData.tail_num}
            onChange={handleChange}
          />
          <label htmlFor="seat_capacity">seat_capacity</label>
          <input
            type="text"
            id="seat_capacity"
            name="seat_capacity"
            value={formData.seat_capacity}
            onChange={handleChange}
          />
          <label htmlFor="speed">speed</label>
          <input
            type="text"
            id="speed"
            name="speed"
            value={formData.speed}
            onChange={handleChange}
          />
          <label htmlFor="locationID">locationID</label>
          <input
            type="text"
            id="locationID"
            name="locationID"
            value={formData.locationID}
            onChange={handleChange}
          />
          <label htmlFor="plane_type">plane_type</label>
          <input
            type="text"
            id="plane_type"
            name="plane_type"
            value={formData.plane_type}
            onChange={handleChange}
          />
          <label htmlFor="skids">skids</label>
          <input
            type="text"
            id="skids"
            name="skids"
            value={formData.skids}
            onChange={handleChange}
          />
          <label htmlFor="propellers">propellers</label>
          <input
            type="text"
            id="propellers"
            name="propellers"
            value={formData.propellers}
            onChange={handleChange}
          />
          <label htmlFor="jet_engines">jet_engines</label>
          <input
            type="text"
            id="jet_engines"
            name="jet_engines"
            value={formData.jet_engines}
            onChange={handleChange}
          />
          <button type="submit">Submit</button>
        </form>
      </fieldset>
    </div>
  );
};

export default AddAirplane;
