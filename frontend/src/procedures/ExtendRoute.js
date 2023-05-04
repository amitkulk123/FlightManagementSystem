import { useEffect, useState } from "react";
import api from "../components/api";

const ExtendRoute = () => {
  const [formData, setFormData] = useState({
    routeID: "eastbound_south_milk_run",
    legID: "leg_11",
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
      const response = await api.post("/extendRoute", formData);
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
          <button type="submit">Extend Route</button>
        </form>
      </fieldset>
    </div>
  );
};

export default ExtendRoute;
