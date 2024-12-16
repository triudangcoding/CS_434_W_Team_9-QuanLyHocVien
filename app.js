// Requiring modules
const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const Connection = require('tedious').Connection
const Request = require('tedious').Request

app.use(bodyParser.json());
app.use(function (req, res, next) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, PATCH, DELETE"
  );
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  res.setHeader("Access-Control-Allow-Credentials", true);
  next();
});
app.listen(5000, function (err) {
  if (err) {
    console.error("Error occurred while starting the server:", err);
  } else {
    console.log("Server is listening at port 5000...");
  }
});
// const config = {
//   user: 'sa',
//   password: '299004',
//   server: 'DESKTOP-64U4BECK',
//   database: 'QLDIEM',
//   options: {
//     trustServerCertificate: true,
//     encrypt: false
//   }
// };

const config = {
  server: 'localhost\\MSSQLSERVER',
  authentication: {
    type: 'default',
    options: {
      userName: 'sa', // update me
      password: '299004' // update me
    }
  },
  options: {
    database: 'QLDIEM', // Đảm bảo rằng bạn cung cấp tên cơ sở dữ liệu chính xác
    encrypt: false, // Thêm vào vì trong hình encryption là Optional
    trustServerCertificate: true,
    port: 1433, // thêm port

  }
}

function connectToSqlServer() {
  console.log('Connecting');
  
  const connection = new Connection(config)
  
  connection.on('connect', (err) => {
    console.log('aa');
    
    if (err) {
      console.log(err)
    } else {
      console.log('Connected to database');
      executeStatement()
    }
  })
  connection.connect();
}
connectToSqlServer();

async function test () {
  const query = "SELECT ID, TenMonHoc, SoTiet FROM MONHOC"; 

  const request = new Request(query, (err, rowCount) => {
    if (err) {
      console.log('Error executing query:', err);
    } else {
      console.log(`${rowCount} rows returned`);
    }
    connection.close();
  });

  request.on('row', (columns) => {
    columns.forEach((column) => {
      // Kiểm tra và in ra giá trị của từng cột
      if (column.value === null) {
        console.log('NULL');
      } else {
        console.log(column.value);
      }
    });
  });

  connection.execSql(request);
}
// test()

 

app.post("/subjects/create", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { mamh, tenmh, sotc } = req.body;
    request.input("p_mamh", mssql.NVarChar, mamh);
    request.input("p_tenmh", mssql.NVarChar, tenmh);
    request.input("p_sotc", mssql.Int, Number(sotc));
    request.output("message", mssql.NVarChar);

    const result = await request.execute("InsertMONHOC");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/subjects/update", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { MAMH, TENMH, SOTC } = req.body;
    request.input("u_mamh", mssql.NVarChar, MAMH);
    request.input("u_tenmh", mssql.NVarChar, TENMH);
    request.input("u_sotc", mssql.Int, Number(SOTC));
    request.output("message", mssql.NVarChar);
    const result = await request.execute("UpdateMONHOC");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/subjects/delete", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("MaMH", mssql.NVarChar, req.body.MAMH);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("DeleteMonHoc");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.get("/subjects/get-data", async function (req, res) {
  try {
    const request = new mssql.Request();
    const result = await request.execute("GetAllMonHoc");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.get("/students/get-data", async function (req, res) {
  try {
    const request = new mssql.Request();
    const result = await request.execute("GetAllSinhVien");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/subjects/create", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { MASV, TENSV, HOLOT, NGAYSINH, DIACHI, DIENTHOAI, MALOP, PHAI } =
      req.body;
    request.input("p_mamh", mssql.NVarChar, MASV);
    request.input("p_tensv", mssql.NVarChar, TENSV);
    request.input("p_holot", mssql.NVarChar, HOLOT);
    request.input("p_ngaysinh", mssql.NVarChar, NGAYSINH);
    request.input("p_diachi", mssql.NVarChar, DIACHI);
    request.input("p_dienthoai", mssql.NVarChar, DIENTHOAI);
    request.input("p_malop", mssql.NVarChar, MALOP);
    request.input("p_phai", mssql.NVarChar, PHAI);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("InsertSinhVien");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.get("/classes/get-data", async function (req, res) {
  try {
    const request = new mssql.Request();
    const result = await request.execute("GetAllLop");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/update", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { MASV, TENSV, HOLOT, NGAYSINH, DIACHI, DIENTHOAI, MALOP, PHAI } =
      req.body;
    request.input("u_masv", mssql.NVarChar, MASV);
    request.input("u_tensv", mssql.NVarChar, TENSV);
    request.input("u_holot", mssql.NVarChar, HOLOT);
    request.input("u_ngaysinh", mssql.NVarChar, NGAYSINH);
    request.input("u_diachi", mssql.NVarChar, DIACHI);
    request.input("u_dienthoai", mssql.NVarChar, DIENTHOAI);
    request.input("u_malop", mssql.NVarChar, MALOP);
    request.input("u_phai", mssql.Bit, PHAI);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("UpdateSINHVIEN");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/delete", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("masv", mssql.NVarChar, req.body.MASV);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("DeleteSINHVIEN");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/create", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { MASV, TENSV, HOLOT, NGAYSINH, DIACHI, DIENTHOAI, MALOP, PHAI } =
      req.body;
    request.input("p_masv", mssql.NVarChar, MASV);
    request.input("p_tensv", mssql.NVarChar, TENSV);
    request.input("p_holot", mssql.NVarChar, HOLOT);
    request.input("p_ngaysinh", mssql.NVarChar, NGAYSINH);
    request.input("p_diachi", mssql.NVarChar, DIACHI);
    request.input("p_dienthoai", mssql.NVarChar, DIENTHOAI);
    request.input("p_malop", mssql.NVarChar, MALOP);
    request.input("p_phai", mssql.Bit, PHAI);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("InsertSinhVien");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/classes/create", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { MALOP, TENLOP, CVHT } = req.body;
    request.input("p_malop", mssql.NVarChar, MALOP);
    request.input("p_tenlop", mssql.NVarChar, TENLOP);
    request.input("p_cvht", mssql.NVarChar, CVHT);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("InsertLOP");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/classes/update", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { MALOP, TENLOP, CVHT } = req.body;
    request.input("u_malop", mssql.NVarChar, MALOP);
    request.input("u_tenlop", mssql.NVarChar, TENLOP);
    request.input("u_cvht", mssql.NVarChar, CVHT);
    request.output("message", mssql.NVarChar);
    const result = await request.execute("UpdateLOP");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/classes/delete", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("MaLop", mssql.NVarChar, req.body.MALOP);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("DeleteLop");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.get("/scores/get-data", async function (req, res) {
  try {
    const request = new mssql.Request();
    const result = await request.execute("GetAllDiem");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/scores/create", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { DIEMCC, DIEMCK, DIEMGK, DiemDA, DiemTD, MAMH, MASV } = req.body;
    request.input("p_masv", mssql.NVarChar, MASV);
    request.input("p_mamh", mssql.NVarChar, MAMH);
    request.input("p_diemcc", mssql.Float, Number(DIEMCC));
    request.input("p_diemtd", mssql.Float, Number(DiemTD));
    request.input("p_diemgk", mssql.Float, Number(DIEMGK));
    request.input("p_diemda", mssql.Float, Number(DiemDA));
    request.input("p_diemck", mssql.Float, Number(DIEMCK));
    request.output("message", mssql.NVarChar);

    const result = await request.execute("InsertDIEM");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/scores/update", async function (req, res) {
  try {
    const request = new mssql.Request();
    const { DIEMCC, DIEMCK, DIEMGK, DiemDA, DiemTD, MAMH, MASV } = req.body;
    request.input("u_masv", mssql.NVarChar, MASV);
    request.input("u_mamh", mssql.NVarChar, MAMH);
    request.input("u_diemcc", mssql.Float, Number(DIEMCC));
    request.input("u_diemtd", mssql.Float, Number(DiemTD));
    request.input("u_diemgk", mssql.Float, Number(DIEMGK));
    request.input("u_diemda", mssql.Float, Number(DiemDA));
    request.input("u_diemck", mssql.Float, Number(DIEMCK));
    request.output("message", mssql.NVarChar);

    const result = await request.execute("UpdateDIEM");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/scores/delete", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("MaSV", mssql.NVarChar, req.body.MASV);
    request.input("MaMH", mssql.NVarChar, req.body.MAMH);
    request.output("message", mssql.NVarChar);

    const result = await request.execute("DeleteDiem");
    res.send({ message: result.output.message });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/login", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("masv", mssql.NVarChar, req.body.MASV);
    request.input("matkhau", mssql.NVarChar, req.body.MATKHAU);
    request.output("message", mssql.NVarChar);
    request.output("status", mssql.Int);
    const result = await request.execute("authenticate_user");
    res.send({ message: result.output.message, status: result.output.status });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/change-password", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("cp_masv", mssql.NVarChar, req.body.MASV);
    request.input("cp_matkhau", mssql.NVarChar, req.body.MATKHAU);
    request.input("matkhau_xacnhan", mssql.NVarChar, req.body.MATKHAUXACNHAN);
    request.output("message", mssql.NVarChar);
    request.output("status", mssql.Int);
    const result = await request.execute("ChangePassword");
    res.send({ message: result.output.message, status: result.output.status });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/get-students-by-class", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("p_malop", mssql.NVarChar, req.body.choose);
    const result = await request.execute("HienThiSinhVienTheoLop");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.post("/students/get-students-by-code", async function (req, res) {
  try {
    const request = new mssql.Request();
    request.input("ht_masv", mssql.NVarChar, req.body.choose);
    const result = await request.execute("HienThiSinhVien");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});

app.get("/students/get-top-students", async function (req, res) {
  try {
    const request = new mssql.Request();
    const result = await request.execute("GetTopStudentsByClass");
    res.send({ data: result.recordset });
  } catch (err) {
    res.status(500).send("Error executing stored procedure: " + err.message);
  }
});


