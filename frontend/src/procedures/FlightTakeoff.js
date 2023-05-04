import { useEffect, useState } from "react";
import api from "../components/api";

const FlightTakeoff = () => {
  const [formData, setFormData] = useState({
    flightID: "DL_1174",
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
      const response = await api.post("/flightTakeoff", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <label htmlFor="flightID">flightID</label>
          <input
            type="text"
            id="flightID"
            name="flightID"
            value={formData.flightID}
            onChange={handleChange}
          />
          <button type="submit">Flight Takeoff</button>
        </form>
      </fieldset>
    </div>
  );
};

export default FlightTakeoff;
