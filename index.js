const express=require("express");
const mongoose=require("mongoose");
const app=express();
const Port=process.env.port||2000;
mongoose.connect("mongodb+srv://bloguser:vicky1234@cluster0.7ngse.mongodb.net/blogappdatabase?retryWrites=true&w=majority",
{
    useNewUrlParser:true,
}
);
const connection=mongoose.connection;
connection.once("open",()=>{
    console.log("Connected to mongodb");
});

//middlewares
app.use(express.json());
const userRoute=require('./routes/user.js');
app.use("/user",userRoute);

app.route("/").get((req,res)=>{res.json("api02")});
app.listen(Port,()=>console.log(`Port  ${Port}`)); 