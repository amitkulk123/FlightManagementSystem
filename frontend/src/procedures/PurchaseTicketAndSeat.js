import { useEffect, useState } from "react";
import api from "../components/api";

const PurchaseTicketAndSeat = () => {
  const [formData, setFormData] = useState({
    ticketID: "tkt_dl_20",
    cost: "450",
    carrier: "DL_1174",
    customer: "p23",
    deplane_at: "JFK",
    seat_number: "5A",
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
      const response = await api.post("/purchaseTicket", formData);
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <label htmlFor="ticketID">ticketID</label>
          <input
            type="text"
            id="ticketID"
            name="ticketID"
            value={formData.ticketID}
            onChange={handleChange}
          />
          <label htmlFor="cost">cost</label>
          <input
            type="text"
            id="cost"
            name="cost"
            value={formData.cost}
            onChange={handleChange}
          />
          <label htmlFor="carrier">carrier</label>
          <input
            type="text"
            id="carrier"
            name="carrier"
            value={formData.carrier}
            onChange={handleChange}
          />
          <label htmlFor="customer">customer</label>
          <input
            type="text"
            id="customer"
            name="customer"
            value={formData.customer}
            onChange={handleChange}
          />
          <label htmlFor="deplane_at">deplane_at (dropdown)</label>
          <input
            type="text"
            id="deplane_at"
            name="deplane_at"
            value={formData.deplane_at}
            onChange={handleChange}
          />
          <label htmlFor="seat_number">seat_number</label>
          <input
            type="text"
            id="seat_number"
            name="seat_number"
            value={formData.seat_number}
            onChange={handleChange}
          />

          <button type="submit">Purchase Ticket and Seat</button>
        </form>
      </fieldset>
    </div>
  );
};

export default PurchaseTicketAndSeat;
