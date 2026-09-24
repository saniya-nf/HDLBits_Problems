module ten_pulses_after_button(
    input clk,rst,button,
    output reg pulse_out
);

//sync button to clk
reg btn_sync0.btn_sync1;

always@(posedge clk,posedge rst)
if(rst)begin
    btn_sync0<=0;
    btn_sync_1<=0;
end
else begin
    btn_sync0<=button;
    btn_sync1<=btn_sync0;
end

//edge detect: rising edge of the sync button
reg btn_sync1_prev;
wire btn_rising_edge=btn_sync_1 & ~btn_sync1_prev;

always@(posedge clk,posedge rst)begin 
    if(rst)
    btn_sync1_prev<=0;
    else
    btn_sync1_prev<=btn_sync1;
end

//fsm and counter
typedef enum logic {
    IDLE=1'b0,RUN=1'b1}state_t;
    state_t,next_state;
    reg[3:0]count; 

    //next state and count logic
    always@(*)begin 
        next_state=state;
        if(state==IDLE)begin
            if(btn_rising)
                next_state<=RUN;//start on button rising edge 
        end
        else begin 
            if(count==4'd9)
                next_state<=IDLE;//after producing 10 pulses
        end
    end

    //sequential--state,count,pulse generation
    always@(posedge clk,posedge rst)begin 
        if (rst)begin 
            state<=IDLE;
            count<=0;
            pulse_out<=0;
        end
        else begin
            state<=next_state;
            if(state==IDLE)begin 
                count<=0;
                pulse_out<=0;//if button is pressed and we move to run on this clk,start producing 1st pulse
                
            end
    end
    