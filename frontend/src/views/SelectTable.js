// import { useEffect, useState } from "react";
// import api from "../components/api";
// // import css
// import "../components/SelectTable.css";

// const SelectTable = (props) => {
//   const [selectTable, getSelectTable] = useState([]);

//   useEffect(() => {
//     api
//       // get it from props.setTable
//       .get("/" + props.currentTable)
//       .then((response) => {
//         getSelectTable(response.data);
//       })
//       .catch((error) => {
//         console.log(error);
//       });
//   }, []);

//   const renderTableHeaders = () => {
//     if (selectTable.length > 0) {
//       const keys = Object.keys(selectTable[0]);
//       return (
//         <tr>
//           {keys.map((key, index) => (
//             <th key={index}>{key}</th>
//           ))}
//         </tr>
//       );
//     }
//   };

//   const renderTableData = () => {
//     return (
//       selectTable &&
//       selectTable.map((item, index) => {
//         const values = Object.values(item);
//         return (
//           <tr key={index}>
//             {values.map((value, index) => (
//               <td key={index}>{value}</td>
//             ))}
//           </tr>
//         );
//       })
//     );
//   };

//   return (
//     <table>
//       <thead>{renderTableHeaders()}</thead>
//       <tbody>{renderTableData()}</tbody>
//     </table>
//   );
// };

// export default SelectTable;

import { useEffect, useMemo, useState } from "react";
import api from "../components/api";
import { useTable, useSortBy } from "react-table";

// import css
import "../components/SelectTable.css";

const SelectTable = (props) => {
  const [selectTable, getSelectTable] = useState([]);

  useEffect(() => {
    api
      // get it from props.setTable
      .get("/" + props.currentTable)
      .then((response) => {
        getSelectTable(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  const columns = useMemo(() => {
    if (selectTable.length > 0) {
      const keys = Object.keys(selectTable[0]);
      return keys.map((key) => {
        return {
          Header: key,
          accessor: key,
        };
      });
    } else {
      return [];
    }
  }, [selectTable]);

  const { getTableProps, getTableBodyProps, headerGroups, rows, prepareRow } =
    useTable({ columns, data: selectTable }, useSortBy);

  const renderTableHeaders = () => {
    return (
      <thead>
        {headerGroups.map((headerGroup) => (
          <tr {...headerGroup.getHeaderGroupProps()}>
            {headerGroup.headers.map((column) => (
              <th
                {...column.getHeaderProps(column.getSortByToggleProps())}
                className={
                  column.isSorted
                    ? column.isSortedDesc
                      ? "sort-desc"
                      : "sort-asc"
                    : ""
                }
              >
                {column.render("Header")}
                <span>
                  {column.isSorted ? (column.isSortedDesc ? " ▼" : " ▲") : ""}
                </span>
              </th>
            ))}
          </tr>
        ))}
      </thead>
    );
  };

  const renderTableData = () => {
    return (
      <tbody {...getTableBodyProps()}>
        {rows.map((row) => {
          prepareRow(row);
          return (
            <tr {...row.getRowProps()}>
              {row.cells.map((cell) => {
                return <td {...cell.getCellProps()}>{cell.render("Cell")}</td>;
              })}
            </tr>
          );
        })}
      </tbody>
    );
  };

  return (
    <table {...getTableProps()}>
      {renderTableHeaders()}
      {renderTableData()}
    </table>
  );
};

export default SelectTable;
