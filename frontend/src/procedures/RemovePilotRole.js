import { useEffect, useState } from "react";
import api from "../components/api";

const RemovePilotRole = () => {
  const [formData, setFormData] = useState({
    personID: "p20",
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
      const response = await api.post("/removePilotRole", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <label htmlFor="personID">personID</label>
          <input
            type="text"
            id="personID"
            name="personID"
            value={formData.personID}
            onChange={handleChange}
          />
          <button type="submit">Remove Pilot Role</button>
        </form>
      </fieldset>
    </div>
  );
};

export default RemovePilotRole;
