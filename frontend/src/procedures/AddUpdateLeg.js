import { useEffect, useState } from "react";
import api from "../components/api";

const AddUpdateLeg = () => {
  const [formData, setFormData] = useState({
    legID: "leg_28",
    distance: "2800",
    departure: "DCA",
    arrival: "SEA",
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
      const response = await api.post("/addupdateLeg", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <label htmlFor="legID">legID</label>
          <input
            type="text"
            id="legID"
            name="legID"
            value={formData.legID}
            onChange={handleChange}
          />
          <label htmlFor="distance">distance</label>
          <input
            type="text"
            id="distance"
            name="distance"
            value={formData.distance}
            onChange={handleChange}
          />
          <label htmlFor="departure">departure</label>
          <input
            type="text"
            id="departure"
            name="departure"
            value={formData.departure}
            onChange={handleChange}
          />
          <label htmlFor="arrival">arrival</label>
          <input
            type="text"
            id="arrival"
            name="arrival"
            value={formData.arrival}
            onChange={handleChange}
          />

          <button type="submit">Add or Update Leg</button>
        </form>
      </fieldset>
    </div>
  );
};

export default AddUpdateLeg;
