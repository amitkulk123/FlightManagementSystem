import { useEffect, useState } from "react";
import api from "../components/api";

const AddAirport = () => {
  const [formData, setFormData] = useState({
    airportID: "SJC",
    airport_name: "San Jose Mineta International Airport",
    city: "San Jose",
    state: "CA",
    locationID: "null",
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
      const response = await api.post("/addAirport", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <label htmlFor="airportID">airportID</label>
          <input
            type="text"
            id="airportID"
            name="airportID"
            value={formData.airportID}
            onChange={handleChange}
          />
          <label htmlFor="airport_name">airport_name</label>
          <input
            type="text"
            id="airport_name"
            name="airport_name"
            value={formData.airport_name}
            onChange={handleChange}
          />
          <label htmlFor="city">city</label>
          <input
            type="text"
            id="city"
            name="city"
            value={formData.city}
            onChange={handleChange}
          />
          <label htmlFor="state">state</label>
          <input
            type="text"
            id="state"
            name="state"
            value={formData.state}
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

          <button type="submit">Add Airport</button>
        </form>
      </fieldset>
    </div>
  );
};

export default AddAirport;
