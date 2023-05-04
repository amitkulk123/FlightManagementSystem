import { useEffect, useState } from "react";
import api from "../components/api";

const StartRoute = () => {
  const [formData, setFormData] = useState({
    routeID: "new_eastbound_west_milk_run",
    legID: "leg_10",
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
      const response = await api.post("/startRoute", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <label htmlFor="routeID">routeID</label>
          <input
            type="text"
            id="routeID"
            name="routeID"
            value={formData.routeID}
            onChange={handleChange}
          />
          <label htmlFor="legID">legID</label>
          <input
            type="text"
            id="legID"
            name="legID"
            value={formData.legID}
            onChange={handleChange}
          />
          <button type="submit">Start Route</button>
        </form>
      </fieldset>
    </div>
  );
};

export default StartRoute;
