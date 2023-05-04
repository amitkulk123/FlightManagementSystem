import { useEffect, useState } from "react";
import api from "../components/api";

const GrantPilotLicense = () => {
  const [formData, setFormData] = useState({
    personID: "p1",
    license: "prop",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => {
      const newData = { ...prevData, [name]: value };
      return newData;
    });
  };

  // when the submit button is pressed, it makes a post request to the backend
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await api.post("/grantPilotLicense", formData);
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
          <label htmlFor="license">license</label>
          <input
            type="text"
            id="license"
            name="license"
            value={formData.license}
            onChange={handleChange}
          />
          <button type="submit">Grant Pilot License</button>
        </form>
      </fieldset>
    </div>
  );
};

export default GrantPilotLicense;
