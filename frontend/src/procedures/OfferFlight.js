import { useEffect, useState } from "react";
import api from "../components/api";

const OfferFlight = () => {
  const [formData, setFormData] = useState({
    flightID: "UN_3403",
    routeID: "westbound_north_milk_run",
    support_airline: "American",
    support_tail: "n380sd",
    progress: "0",
    airplane_status: "on_ground",
    next_time: "15:30:00",
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
      const response = await api.post("/offerFlight", formData);
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
          <label htmlFor="routeID">routeID</label>
          <input
            type="text"
            id="routeID"
            name="routeID"
            value={formData.routeID}
            onChange={handleChange}
          />
          <label htmlFor="support_airline">support_airline</label>
          <input
            type="text"
            id="support_airline"
            name="support_airline"
            value={formData.support_airline}
            onChange={handleChange}
          />
          <label htmlFor="support_tail">support_tail</label>
          <input
            type="text"
            id="support_tail"
            name="support_tail"
            value={formData.support_tail}
            onChange={handleChange}
          />
          <label htmlFor="progress">progress (dropdown)</label>
          <input
            type="text"
            id="progress"
            name="progress"
            value={formData.progress}
            onChange={handleChange}
          />
          <label htmlFor="airplane_status">airplane_status</label>
          <input
            type="text"
            id="airplane_status"
            name="airplane_status"
            value={formData.airplane_status}
            onChange={handleChange}
          />
          <label htmlFor="next_time">next_time</label>
          <input
            type="text"
            id="next_time"
            name="next_time"
            value={formData.next_time}
            onChange={handleChange}
          />

          <button type="submit">Offer Flight</button>
        </form>
      </fieldset>
    </div>
  );
};

export default OfferFlight;
